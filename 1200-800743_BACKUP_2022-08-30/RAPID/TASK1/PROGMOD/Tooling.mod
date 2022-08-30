MODULE Tooling
    
    
    PROC rGripperClose()
        SetDO DOGripperCloseSMC0,0;
    ENDPROC

    PROC rGripperOpen()
        SetDO DOGripperCloseSMC0,1;
    ENDPROC
    
    FUNC bool rGripperIsOpen()
        IF(DOGripperCloseSMC0 = 1) THEN
            RETURN TRUE;
        ENDIF
        RETURN FALSE;
    ENDFUNC


    PROC goHome()
        
        VAR pos CurrentPose;
        CurrentPose:=CPos(\Tool:=tool0\WObj:=wobj0);

        IF CurrentPose.y<-200 THEN
            MoveJ Home_Sensors,v500,z10,CurrentTool;
        ENDIF

        IF CurrentPose.y>120 THEN
            MoveJ Home_Tool,v500,z10,CurrentTool;
        ENDIF

        IF CurrentPose.x>0 THEN
            MoveJ Home,v500,z10,CurrentTool;
        ENDIF

    ENDPROC
    
    
    

ENDMODULE