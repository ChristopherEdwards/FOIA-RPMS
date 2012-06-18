ABSPOSIP ; IHS/FCS/DRS - ABSP INPUT POSTAGE block ;
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 Q
PRE ; PRE action for the page      
 ;D MSGWAIT^ABSPOSI1("DIE="_DIE_", DA="_$G(DA)_", DA(1)="_$G(DA(1)))
 Q
POST ;D MSGWAIT^ABSPOSI1("This is the POST action for the postage page.")
 ; Set the NDC field to POSTAGE $amount
 ; "POSTAGE" is case-sensitive; checked in other places
 N AMT S AMT=$$GET^DDSVAL(DIE,.DA,5.02)
 D PUT^DDSVAL(DIE,.DA,.03,"POSTAGE $"_$J(AMT,0,2))
 Q
