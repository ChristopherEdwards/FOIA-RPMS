DGVREL1 ;ALB/MRL - RELEASE QUESTIONAIRE ; 2 JUN 87
 ;;5.3;Registration;;Aug 13, 1993
120 W !!,"I have stored the initialization times for the initialization process and would",!,"like to view the sizes of your files against these times to better serve your",!,"needs in the future.",! Q
121 W !!,"Please rate the quality of the documentation received.  If none was received",!,"enter a '0'." S DGR="" G R
122 W !!,"Please rate the quality of the Installation Guide.  Was it easy to follow,",!,"accurate, etc.?" G R
123 W !!,"Please rate the quality of the Release Notes.  Were they easy to follow,",!,"informative, etc.?" G R
124 W !!,"How would you rate the overall initialization process now that you've been",!,"thru it?  Did it run smoothly?  Did it run in an acceptable amount of time?" G R
125 W !!,"How would you rate your users initial impression of this release?" G R
126 W !!,"How would you rate this release as a whole?" G R
150 W !!,"Please enter any comments, suggestions, etc., which you feel might assist us in",!,"better assisting you and your users.",! Q
R W !!,"[1]  POOR",?20,"[2]  FAIR",?60,"[3]  GOOD",!,"[4]  VERY GOOD",?20,"[5]  EXCELLENT" I $D(DGR) W ?60,"[0]  NONE INCLUDED"
 W ! K DGR Q
CHK S DGERR=0 I '$D(^DG(48,DGVREL,"R")) W !!,"INITIALIZATION TIMES NOT DEFINED" S DGERR=1 G Q1
 I '$D(^DG(48,DGVREL,"S")) W !!,"SURVEY NOT COMPLETED" S DGERR=1 G Q1
 F I=1:1:7 I $P(^DG(48,DGVREL,"S"),"^",I)']"" S DGERR=1
 I DGERR W !!,"NOT ALL SURVEY ITEMS COMPLETED"
Q1 Q:'DGERR  W "...CAN'T ",$S(DGHOW="M":"TRANSMIT MESSAGE",1:"GENERATE LETTER"),"...",*7 Q
