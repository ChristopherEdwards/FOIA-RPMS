POHLFIX ;IHS/PDW  CORRECT TRIGGER LOGIC IN THE POLICY HOLDER FILE [ 03/16/92  2:25 PM ]
 ;;
S W !,"Deleting the Data Dictionary for the Policy Holder File",!
 S DIU="^AUPN3PPH(",DIU(0)="" D EN^DIU2
 W !,"Reinstalling the Data Dictionary for the Policy Holder File",!
 D ^POHLINIT
 Q
