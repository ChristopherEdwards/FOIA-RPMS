APCDO005 ; IHS/CMI/TUCSON - NO DESCRIPTION PROVIDED ;
 ;;2.0;IHS RPMS/PCC Data Entry;;MAR 09, 1999
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"PRO",1739,20)
 ;;=D DELETE^APCDEH1
 ;;^UTILITY(U,$J,"PRO",1739,99)
 ;;=57510,28764
 ;;^UTILITY(U,$J,"PRO",1740,0)
 ;;=APCDEH HEALTH SUMMARY^Health Summary^^A^^^^^^^^IHS RPMS/PCC Data Entry
 ;;^UTILITY(U,$J,"PRO",1740,20)
 ;;=D HS^APCDEH1
 ;;^UTILITY(U,$J,"PRO",1740,99)
 ;;=57510,28764
 ;;^UTILITY(U,$J,"PRO",1741,0)
 ;;=APCDEH PROBLEM LIST^Problem List Update^^A^^^^^^^^IHS RPMS/PCC Data Entry
 ;;^UTILITY(U,$J,"PRO",1741,20)
 ;;=D PROB^APCDEH1
 ;;^UTILITY(U,$J,"PRO",1741,99)
 ;;=57510,28764
 ;;^UTILITY(U,$J,"PRO",2016,0)
 ;;=APCD3MO SERVER^Server Protocol, PCC to 3M CODER^^E^^^^^^^^IHS RPMS/PCC Data Entry
 ;;^UTILITY(U,$J,"PRO",2016,1,0)
 ;;=^^2^2^2981020^^^^
 ;;^UTILITY(U,$J,"PRO",2016,1,1,0)
 ;;=This protocol is executed when a PCC visit with uncoded V POV entries
 ;;^UTILITY(U,$J,"PRO",2016,1,2,0)
 ;;=is ready to be passed to the 3M Coder for subsequent ICD9 coding.
 ;;^UTILITY(U,$J,"PRO",2016,10,0)
 ;;=^101.01PA^1^1
 ;;^UTILITY(U,$J,"PRO",2016,10,1,0)
 ;;=2017^^^
 ;;^UTILITY(U,$J,"PRO",2016,10,1,"^")
 ;;=APCD3MO CLIENT
 ;;^UTILITY(U,$J,"PRO",2016,20)
 ;;=
 ;;^UTILITY(U,$J,"PRO",2016,99)
 ;;=57638,31011
 ;;^UTILITY(U,$J,"PRO",2016,770)
 ;;=9^^6^8^i^P^^^^^6
 ;;^UTILITY(U,$J,"PRO",2017,0)
 ;;=APCD3MO CLIENT^Client Protocol, PCC to 3M CODER^^S^^^^^^^^IHS RPMS/PCC Data Entry
 ;;^UTILITY(U,$J,"PRO",2017,1,0)
 ;;=^^2^2^2981020^^^^
 ;;^UTILITY(U,$J,"PRO",2017,1,1,0)
 ;;=This client protocol entry generates the outbound HL7 message to
 ;;^UTILITY(U,$J,"PRO",2017,1,2,0)
 ;;=be sent to the 3M Coder for ICD coding.
 ;;^UTILITY(U,$J,"PRO",2017,99)
 ;;=57638,31011
 ;;^UTILITY(U,$J,"PRO",2017,770)
 ;;=10^^^8^i^P^5^^^3^6
 ;;^UTILITY(U,$J,"PRO",2017,773)
 ;;=0^0^0^0
 ;;^UTILITY(U,$J,"PRO",2018,0)
 ;;=APCD3MI SERVER^Server Protocol, 3M CODER to PCC^^E^^^^^^^^IHS RPMS/PCC Data Entry
 ;;^UTILITY(U,$J,"PRO",2018,1,0)
 ;;=^^3^3^2981019^^^^
 ;;^UTILITY(U,$J,"PRO",2018,1,1,0)
 ;;=This protocol is executed when a message is received from the 3M
 ;;^UTILITY(U,$J,"PRO",2018,1,2,0)
 ;;=Coder to update the V POV entreis with the ICD9 code assigned by
 ;;^UTILITY(U,$J,"PRO",2018,1,3,0)
 ;;=the 3M Coder.
 ;;^UTILITY(U,$J,"PRO",2018,10,0)
 ;;=^101.01PA^1^1
 ;;^UTILITY(U,$J,"PRO",2018,10,1,0)
 ;;=2019^^^
 ;;^UTILITY(U,$J,"PRO",2018,10,1,"^")
 ;;=APCD3MI CLIENT
 ;;^UTILITY(U,$J,"PRO",2018,99)
 ;;=57638,31011
 ;;^UTILITY(U,$J,"PRO",2018,770)
 ;;=9^10^6^8^i^P^^^^3^
 ;;^UTILITY(U,$J,"PRO",2018,771)
 ;;=
 ;;^UTILITY(U,$J,"PRO",2018,773)
 ;;=0^0^0^0
 ;;^UTILITY(U,$J,"PRO",2019,0)
 ;;=APCD3MI CLIENT^Client Protocol, 3M CODER to PCC^^S^^^^^^^^IHS RPMS/PCC Data Entry
 ;;^UTILITY(U,$J,"PRO",2019,1,0)
 ;;=^^2^2^2981019^^^
 ;;^UTILITY(U,$J,"PRO",2019,1,1,0)
 ;;=This client protocol entry installs the inbound HL7 message from the
 ;;^UTILITY(U,$J,"PRO",2019,1,2,0)
 ;;=3M Coder.
 ;;^UTILITY(U,$J,"PRO",2019,99)
 ;;=57638,31011
 ;;^UTILITY(U,$J,"PRO",2019,770)
 ;;=^10^6^8^i^P^^^^3^
 ;;^UTILITY(U,$J,"PRO",2019,771)
 ;;=D IN^APCD3M
 ;;^UTILITY(U,$J,"PRO",2019,773)
 ;;=0^0^0^0
