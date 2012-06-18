AZHAFIX ;FIX ROUTINE [ 08/13/2003  12:27 PM ]
 ;;
START ;start
 W !!,"Checking Private Insurance Eligible File",!!
 S I=0
BY ;bypass with I set
 F  S I=$O(^AUPNPRVT(I)) Q:'I  D
 .I '(I#100) W "."
 .S J=0
 .F  S J=$O(^AUPNPRVT(I,11,J)) Q:'J  D
 ..D ONE
 W !!,"Done",!!
 Q
ONE ;one entry
 Q:+$G(^AUPNPRVT(I,11,J,0))
 W !," bad entry at ien: ",I,"  ^AUPNPRVT(",I,",11,",J,",0)=",^AUPNPRVT(I,11,J,0),!
 K ^AUPNPRVT(I,11,J,0) W "fixed"
 Q
