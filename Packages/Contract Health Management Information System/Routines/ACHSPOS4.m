ACHSPOS4 ; IHS/ITSC/PMF - DATA FOR DENIAL FACILITY FILE ;  [ 10/19/2001  11:00 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 ;CURRENTLY THE NODES THE CHS WORKGROUP WANTS TO BE MANDATED. THE
 ;CONTENT OF THESE NODES WILL BE AUTHORED BY THE WORKGROUP AND ONCE
 ;WRITTEN WILL BE INSTALLED AT THE SITES. THESE FIELDS ARE NOT
 ;EDITABLE FROM THE MENUS.
 ;THE NODES ARE:
 ;   2  'MIDDLE TEXT'
 ;   3  'BOTTOM TEXT'
 ;   7  'TEXT FOR SIGNATURE' 
 ;   9  'CLOSING TEXT'
 ;
 ;WHEN INSTALLING SET THE 'MANDATED' VAR EQUAL TO THE STRING OF NODE
 ;NUMBERS SEPARATED BY ^ THAT YOU WISH TO BE MANDATED. IF THE NODE
 ;NUMBER IS IN THIS STRING IT WILL BE OVERWRITTEN AT THE SITE NO MATTER
 ;WHAT. BEGIN AND END THE STRING WITH ^
 ;E.G.   S U="^"
 ;       S MANDATED=U_2_U_3_U
 ;
 ;YOU CAN USE THIS ROUTINE TO MODIFY/UPDATE THE DENIAL LETTERS TO
 ;REFLECT REGULATORY CHANGES MANDATED BY THE CHS WORKGROUP. IT WILL
 ;UPDATE ACTIVE FACILITIES FOUND in the facility file
 ;
 S U="^"
 S MANDATED=U_2_U_3_U_7_U_9_U      ;MANDATED NODES PER CHS WORKGROUP
 S $ZT="ERROR^"_$ZN                ;AS OF 2/22/01
 S %H=$H D YX^%DTC S NOW=Y
 S ^ACHSINST(ACHSVERS,$ZN,"ENTERED")=NOW
 ;
 I $D(ACHSINST(ACHSVERS,"ERROR")) S ^ACHSINST(ACHSVERS,"ERROR","PREVIOUS ERRORS HAVE NOT BEEN CLEARED")=NOW S ERROR=1 S XPDABORT=1 Q
 ;
 ;
MAIN N A,B,C
 F A=1:2 S B=$P($T(TAG+A),";;",2) Q:B=""  S @B=$P($T(TAG+(A+1)),";;",2)
 ;
 ;FOR EACH ACTIVE FACILITY FOUND SET UP
 ;INITIAL 'CHS DENIAL FACILITY' ENTRY
 S ^ACHSINST(ACHSVERS,$ZN,"SET UP CHS DENIAL FACILITY ENTRIES","STARTED")=NOW
 ;
 S ACHSFAC="" F  S ACHSFAC=$O(^ACHSF("B",ACHSFAC)) Q:ACHSFAC=""  D ENTER
 ;
 ;INDEX THE FILE
 S DIK="^ACHSDENR("
 D IXALL^DIK
 ;
 S ^ACHSINST(ACHSVERS,$ZN,"SET UP CHS DENIAL FACILITY ENTRIES","FINISHED")=NOW
 ;
END S %H=$H D YX^%DTC S NOW=Y
 S ^ACHSINST(ACHSVERS,$ZN,"FINISHED")=NOW
 ;
 Q
ENTER ;PLACE CODE FOR FORCE ENTRY TO ^ACHSDENR HERE
 ;
 S %H=$H D YX^%DTC S NOW=Y
 S ^ACHSINST(ACHSVERS,"ENTER^"_$ZN,"ENTERED")=NOW
 ;
 I $D(^ACHSDENR(ACHSFAC,0)) W !?15,"'CHS DENIAL FACILITY' data for ",ACHSFAC," found! Loading mandatory data!"
 E  W !?15,"'CHS DENIAL FACILITY' data for ",ACHSFAC," not found! Loading complete data!"
 ;
 ;OVERWRITE NODES THAT ARE CONTAINED BY VARIABLE 'MANDATED'
 ;FIRST WE'LL GET RID OF THOSE NAUGHTY NODES
 F PIECE=2:1 S NODE=$P(MANDATED,U,PIECE) Q:NODE=""  D
 .K ^ACHSDENR(ACHSFAC,NODE)
 ;
 S X="^TMP("_$J_",""FAC"")"
 F  S X=$Q(@X) Q:X=""!(X'[("""FAC"""))!($P($P(X,","),"(",2)'=$J)  D
 .S GLOBAL="^ACHSDENR("_ACHSFAC_$P(X,"""FAC""",2)
 .I @X[("ACHSFAC") D
 ..Q:$D(@GLOBAL)                    ;DO NOT SET IF ALREADY THERE
 ..S @GLOBAL=ACHSFAC_U_$P(@X,U,2,99)
 .E  Q:$D(@GLOBAL)  S @GLOBAL=@X    ;IF ALREADY THERE LEAVE
 ;
 S %H=$H D YX^%DTC S NOW=Y
 S ^ACHSINST(ACHSVERS,"ENTER^"_$ZN,"FINISHED")=NOW
 Q
 ;
 ;****USED INDEPENDENTLY OF A GENERAL INSTALL***
 ;UPDATE DENIAL LETTERS FOR ACTIVE FACILITIES BASED ON CHS WORKGROUP
 ;MANDATORY CHANGE IN DENIAL LETTERS
 ;STEP 1) SET THE VARIABLE MANDATED TO INCLUDE THE NODES WHICH WILL
 ;        BE CHANGED WHETHER SITES WANT IT OR NOT
 ;STEP 2) CHANGE THE TEXT TO BE CHANGED IN THE LINES PAST TAG 'TAG'
 ;
UPDATE ;
 S U="^",$P(LINE,"*",81)=""
 S %H=$H D YX^%DTC S NOW=Y
 S ACHSVERS="V"_$P($P($T(+2),";;",2),";")
 S ^ACHSINST("UPDATE",ACHSVERS,"UPDATE^"_$ZN,"ENTERED")=NOW
 ;
 S MANDATED=U_2_U_3_U_7_U_9_U    ;INCLUDE NODES TO BE OVERWRITTEN
 D MAIN                          ;INSTALL NEW DENIAL LETTER ENTRIES
 ;
 S %H=$H D YX^%DTC S NOW=Y
 S ^ACHSINST("UPDATE",ACHSVERS,"UPDATE^"_$ZN,"FINISHED")=NOW
 Q
 ;
ERROR S ^ACHSINST(ACHSVERS,"ERROR",$ZN,"ERROR TRAP CALLED")=NOW
 G ^%ET
 Q
TAG ;
 ;;^TMP($J,"FAC",0)
 ;;ACHSFAC^^1^1^1^N^N
 ;;^TMP($J,"FAC",2,0)
 ;;^9002072.03^2^2
 ;;^TMP($J,"FAC",2,1,0)
 ;;We have been requested to authorize payment for services received from the above provider(s).  Regretfully, we must advise you the Indian Health
 ;;^TMP($J,"FAC",2,2,0)
 ;;Service (IHS) will not pay for charges for the following reason(s):
 ;;^TMP($J,"FAC",3,0)
 ;;^9002072.04^1^3
 ;;^TMP($J,"FAC",3,1,0)
 ;;If you have additional information that may be helpful in reconsidering
 ;;^TMP($J,"FAC",3,2,0)
 ;;our decision, please submit, in writing, within 30 days of receipt of this
 ;;^TMP($J,"FAC",3,3,0)
 ;;letter to:
 ;;^TMP($J,"FAC",7,0)
 ;;^9002072.07^1^1
 ;;^TMP($J,"FAC",7,1,0)
 ;;Sincerely,
 ;;^TMP($J,"FAC",9,0)
 ;;^9002072.11^1^1
 ;;^TMP($J,"FAC",9,1,0)
 ;;If you do not have additional information, you may appeal in writing, within 30 days of receipt of this letter:
 ;;^TMP($J,"FAC",10,0)
 ;;^9002072.08^10^10
 ;;^TMP($J,"FAC",10,1,0)
 ;;The information provided to the CHS office indicates that you may be
 ;;^TMP($J,"FAC",10,2,0)
 ;;qualified for an alternate resource.  Pursuant to IHS regulations, 42 CFR
 ;;^TMP($J,"FAC",10,3,0)
 ;;Part C, you are required to make a good faith effort to apply for and
 ;;^TMP($J,"FAC",10,4,0)
 ;;complete an application for alternate resources.  You must provide this
 ;;^TMP($J,"FAC",10,5,0)
 ;;facility with a copy of the alternate resource program's eligibility
 ;;^TMP($J,"FAC",10,6,0)
 ;;determination.
 ;;^TMP($J,"FAC",10,7,0)
 ;; 
 ;;^TMP($J,"FAC",10,8,0)
 ;; 
 ;;^TMP($J,"FAC",10,9,0)
 ;;THE APPLICATION PROCESS REQUIRES YOU TO DO THE FOLLOWING:
 ;;^TMP($J,"FAC",10,10,0)
 ;; 
 ;;^TMP($J,"FAC",11,0)
 ;;^9002072.011^6^6
 ;;^TMP($J,"FAC",11,1,0)
 ;;IF YOU ARE UNABLE TO APPLY FOR AN ALTERNATE RESOURCE OR ARE HAVING
 ;;^TMP($J,"FAC",11,2,0)
 ;;DIFFICULTY APPLYING, THE CHS OFFICE IS AVAILABLE TO ASSIST YOU.  PLEASE
 ;;^TMP($J,"FAC",11,3,0)
 ;;CONTACT THE OFFICE LISTED BELOW FOR ASSISTANCE.  IF AN ALTERNATE RESOURCE
 ;;^TMP($J,"FAC",11,4,0)
 ;;APPLICATION IS NOT COMPLETED, OR IF YOU DO NOT CONTACT THE CHS OFFICE FOR
 ;;^TMP($J,"FAC",11,5,0)
 ;;ASSISTANCE IN COMPLETING AN APPLICATION, WITHIN 30 DAYS OF THE DATE OF THIS
 ;;^TMP($J,"FAC",11,6,0)
 ;;NOTICE, THIS CHS PAYMENT DENIAL LETTER WILL BECOME FINAL.
 ;;^TMP($J,"FAC",12,0)
 ;;^9002072.012A^4^4
 ;;^TMP($J,"FAC",12,1,0)
 ;;CONTACT ALT RES
 ;;^TMP($J,"FAC",12,1,1,0)
 ;;CONTACT ALT RES
 ;;^TMP($J,"FAC",12,1,1,1,0)
 ;;You must contact the other resource(s) listed above to make an application,
 ;;^TMP($J,"FAC",12,1,1,2,0)
 ;;schedule an appointment, and attend the appointment as scheduled.
 ;;^TMP($J,"FAC",12,2,0)
 ;;PROVIDE DOCUMENTATION
 ;;^TMP($J,"FAC",12,2,1,0)
 ;;CONTACT ALT RES
 ;;^TMP($J,"FAC",12,2,1,1,0)
 ;;You will need to bring the listed documentation to the appointment.  You
 ;;^TMP($J,"FAC",12,2,1,2,0)
 ;;might also have to provide the alternate resource program with additional
 ;;^TMP($J,"FAC",12,2,1,3,0)
 ;;documentation specifically requested prior to or during the appointment.
 ;;^TMP($J,"FAC",12,3,0)
 ;;TRANSPORTATION
 ;;^TMP($J,"FAC",12,3,1,0)
 ;;CONTACT ALT RES
 ;;^TMP($J,"FAC",12,3,1,1,0)
 ;;The CHS office will provide transportation for you to attend your scheduled appointment.  Please contact the office listed below for more information.
 ;;^TMP($J,"FAC",12,4,0)
 ;;FREE TEXT
 ;;^TMP($J,"FAC",13,0)
 ;;^9002072.013^2^2
 ;;^TMP($J,"FAC",13,1,0)
 ;;PROGRAM NOT RESPONSIBLE
 ;;^TMP($J,"FAC",13,1,1,0)
 ;;^9002072.013^4^4^2940809^^
 ;;^TMP($J,"FAC",13,1,1,1,0)
 ;;The IHS appeals this decision denying payment of medical care benefits solely because the program views itself as not responsible for Native American health care because the IHS is the "primary" payor for such care.
 ;;^TMP($J,"FAC",13,1,1,2,0)
 ;;Such decisions lack any legal basis and may violate county, state, and/or federal law, including, but not limited to, the equal protection clause of the fourteenth amendment to the United States Constitution and the
 ;;^TMP($J,"FAC",13,1,1,3,0)
 ;;"payor of last resort rule" governing allocation of Indian Health Service resources, see 55 F.R. 4606(February 9, 1990); Mcnabb v. Bowen, 829 F.2d 787, 790 (9th Cir, 1987); State of Arizona v. United States, No. 87-2525
 ;;^TMP($J,"FAC",13,1,1,4,0)
 ;;(9th Cir. September 12, 1990 - unpublished memorandum); State of Arizona v. United States, No. 86-1105 PHX CLH, (May 18, 1990 - unpublished memorandum decision).
 ;;^TMP($J,"FAC",13,2,0)
 ;;FREE TEXT
 ;;^TMP($J,"FAC",100)
 ;;SERVICE UNIT DIRECTOR^STREET ADDRESS^CITY^STATE^ZIP^TELEPHONE
 ;;^TMP($J,"FAC",200)
 ;;AREA DIRECTOR^STREET ADDRESS^CITY^STATE^ZIP^TELEPHONE 
 ;;
