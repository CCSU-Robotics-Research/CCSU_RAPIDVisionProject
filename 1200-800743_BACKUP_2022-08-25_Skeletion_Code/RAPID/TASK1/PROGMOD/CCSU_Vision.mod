MODULE CCSU_Vision
    
    
    !THIS MODULE CONTAINS THE CODE TO CONTROL THE COGNEX CAMERA AND USE THE DATA IT FINDS
    
    !========================
    !===PERS AND VARIABLES===
    !========================
       
    !TARGETS & CAMERA
    VAR cameratarget CamTarget;
    VAR string CurrentJob:="";

    TASK PERS wobjdata PartWObj:=[FALSE,TRUE,"",[[0,0,0],[1,0,0,0]],[[15.0994,-459.916,273.96],[0.00676161,-0.7229,-0.690918,0.00120951]]];
    TASK PERS wobjdata UpdatedWObj:=[FALSE,TRUE,"",[[0,0,0],[1,0,0,0]],[[15.0994,-459.916,273.96],[0.00676161,-0.7229,-0.690918,0.00120951]]];
    
    !JOBS
    !CONST string VisionPartJob:="PartRotation.job";
    
    
    
    
    
    
      !READY CAMERA
    !SET CAMERA TO RUN MODE AND CHOOSE JOB
    PROC VisionInit(string myjob)

        CurrentJob := CamGetLoadedJob(FORCECamera);

        IF not(CurrentJob = myjob) THEN
            !TPWrite "diffrent job loaded in camera: " + CamGetName(CCSU_FORCE_ABB_Vision);
            CamSetProgramMode FORCECamera;
            CamLoadJob FORCECamera, myjob;    
        ENDIF
        
        TPWrite "Job " + CamGetLoadedJob(FORCECamera) + " is loaded in camera " + CamGetName(FORCECamera);
        CamSetRunMode FORCECamera;

    ENDPROC
    
    
    
     PROC VisionCaptureData()

        CamReqImage FORCECamera;
        CamGetResult FORCECamera,CamTarget;

        IF CamTarget.val1 = 1 THEN
            TPWrite("Nothing detected in Camera: " + CamGetName(FORCECamera)); 
             WaitTime 2; 
            Stop;
        ENDIF
        
    ENDPROC
    
    
      !USE CAMERA TARGET AND MOVE OVER TO THE TARGET FOUND BY CHANGING WOBJ "PartWObj" AND GO TO ZERO ON THAT WOBJ
    !THIS METHOD USES THE CAMERATARGET AND MOVES OVER TO THE TARGET FOUND BY CHANGING THE WORKOBJECT "PartWObj" AND GOING TO ZERO ON THAT WOBJ
    PROC VisionUpdateWObj()
        
        
        VAR num DeltaRotationZ;
        VAR num RotationZ;
        VAR num RotationX;
        VAR num RotationY;
        
        
        !GET AND PARCE DATA
        CamGetParameter FORCECamera,"Pattern_1.Fixture.Angle"\NumVar:=DeltaRotationZ;
        
        IF DeltaRotationZ > 90 THEN
            DeltaRotationZ := DeltaRotationZ - 90;
        ENDIF
        TPWrite("Part Rotation: ")\Num:=DeltaRotationZ;
        
        
        !MAKE CHANGE TO WORKOBJ
        !make change in Euler Angels
        RotationZ := EulerZYX(\Z,PartWObj.oframe.rot)+DeltaRotationZ;
        RotationY := EulerZYX(\Y,PartWObj.oframe.rot);
        RotationX := EulerZYX(\X,PartWObj.oframe.rot);
        
        !Convert to Quaternions (Oirent)
        UpdatedWObj.oframe.rot:=OrientZYX(RotationZ, RotationY, RotationX);
        UpdatedWObj.oframe.rot:= NOrient(UpdatedWObj.oframe.rot);
        

    ENDPROC
    
    
    
ENDMODULE