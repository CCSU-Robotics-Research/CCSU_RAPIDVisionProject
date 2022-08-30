MODULE CCSU_Main
    
    CONST robtarget Home:=[[209.53,5.16,537.39],[0.00328327,0.0146564,-0.99987,0.00586276],[0,-1,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget Home_Sensors:=[[2.66,-209.51,507.39],[0.00651711,-0.708175,-0.706004,0.00177175],[-1,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget Home_tool:=[[4.44,209.54,537.36],[0.00162517,-0.701222,0.712912,-0.00653747],[0,-1,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    
    CONST robtarget CamPartView_10:=[[108.20,-509.34,610.28],[0.485562,0.526428,0.489687,0.497302],[-2,0,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    
    CONST num RotOffset := 0;
    
    
    
    !#########################################################################################################################
    !Code Start 
    !#########################################################################################################################
    PROC Main()
    
    !goHome;
    !MoveJ Home_Sensors , v100, fine, Gripper_FS;
    MoveJ CamPartView_10, v100, fine, Gripper_FS;
    VisionInit("PartRotation.job");
    
    
    FOR i FROM 0 TO 10 DO
    VisionCaptureData;
    VisionUpdateWObj(RotOffset);   
    ENDFOR
    
    
    
    
    MoveJ Home_Sensors , v100, fine, Gripper_FS;
    
    ENDPROC
    
    
    
    
    !#########################################################################################################################
    !FUNCTIONS
    !#########################################################################################################################
    
    !CHANGES INPUT VALUE AND RANGE TO A NEW RANGE WITHOUT LOSING RATIO
    FUNC num changeRangeMaintainRatio(num Value, num OldMin, num OldMax, num NewMin, num NewMax)
        RETURN (((Value - OldMin) * (NewMax - NewMin)) / (OldMax - OldMin)) + NewMin;
    ENDFUNC
    
    
    
    !MOVES UP X UNITS FROM RELATIVE TARGET
    FUNC robtarget GetLocationXUnitsAbove(robtarget relativeVal, num units)
        VAR robtarget setVal;
        setVal := relativeVal;
        setVal.trans.z := relativeVal.trans.z - units;
        RETURN setVal;
    ENDFUNC
    
    
ENDMODULE