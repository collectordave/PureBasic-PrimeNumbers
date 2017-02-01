UseSQLiteDatabase()

Enumeration FormWindow
  #WinMain
  #txtStartNumber
  #strStartNumber
  #txtEndNumber
  #strEndNumber
  #txtElapsedTime
  #strElapsedTime
  #btnCalculate
  #btnCompare
EndEnumeration

Global startTime.q
Global NoStart.i,NoEnd.i
Global NewMap  PrimeList.i()

Procedure.i CheckPrimes1()
  
  Define PrimeDB.i,PrimeOk.i
  Define Criteria.s
  
  PrimeDB = OpenDatabase(#PB_Any,GetCurrentDirectory() + "Prime Numbers.s3db","","")
  PrimeOk = #True
  
  ForEach PrimeList()
    Criteria = "SELECT * FROM Primes WHERE Number = " + Str(PrimeList())
    DatabaseQuery(PrimeDB,Criteria)
    If Not FirstDatabaseRow(PrimeDB)
      PrimeOk = #False
      MessageRequester("Error",Str(PrimeList()) + " Is Not A Prime",#PB_MessageRequester_Ok|#PB_MessageRequester_Error)
      ProcedureReturn PrimeOk     
    EndIf
    FinishDatabaseQuery(PrimeDB)
  Next
  CloseDatabase(PrimeDB)
  
  MessageRequester("Check 1"," Completed Ok",#PB_MessageRequester_Ok|#PB_MessageRequester_Info)
   
  ProcedureReturn PrimeOk
  
EndProcedure

Procedure.i CheckPrimes2()
  
  Define PrimeDB.i,PrimeOk.i
  Define Criteria.s
  
  PrimeDB = OpenDatabase(#PB_Any,GetCurrentDirectory() + "Prime Numbers.s3db","","")
  PrimeOk = #True
  
  Criteria = "SELECT * FROM Primes WHERE Number >  " + Str(NoStart) + " AND Number < " + Str(NoStart)
  DatabaseQuery(PrimeDB,Criteria) 
  
  While NextDatabaseRow(PrimeDB)
  
    If Not FindMapElement(PrimeList(), Str(GetDatabaseLong(PrimeDB,0)))
      PrimeOk = #False
      MessageRequester("Error",Str(GetDatabaseLong(PrimeDB,0)) + " Is Not In List",#PB_MessageRequester_Ok|#PB_MessageRequester_Error)
      ProcedureReturn PrimeOk
    EndIf
    
  Wend
  FinishDatabaseQuery(PrimeDB)

  MessageRequester("Check 2"," Completed Ok",#PB_MessageRequester_Ok|#PB_MessageRequester_Info) 
  
  ProcedureReturn PrimeOk
  
EndProcedure


Procedure GenPrimes(StartNumber.i,EndNumber.i)
  
  Define i.i,j.i,bflag.i
  For i = StartNumber To EndNumber
    bflag = #True
    For j = 2 To i / 2
      If Mod(i, j) = 0
        bflag = False
      EndIf
    Next
    If i > 1 ;1 Is Not A Prime
      If bflag
        PrimeList(Str(i)) = i
      EndIf
    EndIf
  
  Next
  
EndProcedure

OpenWindow(#WinMain, 5, 5, 220, 160, "Prime Number Calculator", #PB_Window_SystemMenu)
TextGadget(#txtStartNumber, 10, 10, 90, 20, "Start Number", #PB_Text_Right)
StringGadget(#strStartNumber, 110, 10, 80, 20, "1")
TextGadget(#txtEndNumber, 10, 40, 90, 20, "End Number", #PB_Text_Right)
StringGadget(#strEndNumber, 110, 40, 80, 20, "100000")
TextGadget(#txtElapsedTime, 10, 70, 90, 20, "Time Taken", #PB_Text_Right)
StringGadget(#strElapsedTime, 110, 70, 80, 20, "")
ButtonGadget(#btnCalculate, 110, 100, 80, 20, "Calculate")
ButtonGadget(#btnCompare, 110, 130, 80, 20, "Compare")

Repeat
    
    Event = WaitWindowEvent()
    Select Event
      Case #PB_Event_CloseWindow
        End

    Case #PB_Event_Gadget
      
      Select EventGadget()
          
        Case #btnCalculate
          
          ClearMap(PrimeList()) 
          NoStart = Val(GetGadgetText(#strStartNumber))
          NoEnd = Val(GetGadgetText(#strEndNumber))          
          StartTime = ElapsedMilliseconds()
          
          GenPrimes(NoStart,NoEnd) 

          SetGadgetText(#strElapsedTime,Str(ElapsedMilliseconds() - StartTime)) 
          
          
        Case #btnCompare
          
          If CheckPrimes1()
            CheckPrimes2()
            
          EndIf
  
      EndSelect
  EndSelect
  
  ForEver
; IDE Options = PureBasic 5.60 Beta 1 (Windows - x64)
; CursorPosition = 66
; FirstLine = 11
; Folding = 8
; EnableXP