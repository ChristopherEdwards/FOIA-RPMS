BKMVAUTR ;PRXM/HC/CLT - AUTOPOPULATE RUN STATUS ; 08 Jun 2005  11:35 AM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
DISP ;DISPLAY AUTOPOPULATE STATUS
 N BKMREG,BKMNODE,BKMQS,BKMQU,BKMPGHD,BKMQX,BKMQ,BKMQUX,BKMQS,Y,BKMQE,QUITF
 S BKMREG=$O(^BKM(90450,"B","HMS REGISTER",0)),BKMNODE=$G(^BKM(90450,BKMREG,13))
 S BKMQS=$P(BKMNODE,U,1),BKMQE=$P(BKMNODE,U,2),BKMQU=$P(BKMNODE,U,5),BKMQ=$P(BKMNODE,U,3)
 S BKMPGHD="Autopopulate Run Status" W @IOF,!!,?IOM-$L(BKMPGHD)\2,BKMPGHD,!!
 S BKMQX=$S(BKMQ="Q":"Queued to run",BKMQ="N":"Not currently running",BKMQ="R":"Currently running",1:"Status not available")
 S BKMQUX=$S(BKMQU'="":$P(^VA(200,BKMQU,0),U,1),1:"No user listed")
 ;I BKMQS'="" S Y=BKMQS D DD^%DT S BKMQS=Y
 I BKMQS'="" S BKMQS=$$FMTE^XLFDT(BKMQS,1)
 S BKMQS=$S(BKMQS="":"No queue time listed",1:BKMQS)
 ;I BKMQE'="" S Y=BKMQE D DD^%DT S BKMQE=Y
 I BKMQE'="" S BKMQE=$$FMTE^XLFDT(BKMQE,1)
 S BKMQE=$S(BKMQE="":"No queue end time listed",1:BKMQE)
 W !!?10,"Current autopopulate run status: ",BKMQX
 W !!?10,"Last run start time: ",BKMQS
 W !!?10,"Last run end time: ",BKMQE
 W !!?10,"User running last task: ",BKMQUX
 S QUITF=$$PAUSE^BKMIXX3("Press ENTER to continue")
 Q
