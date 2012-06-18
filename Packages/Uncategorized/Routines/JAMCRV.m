JAMCRV ;NEW PROGRAM [ 04/08/96  1:41 PM ]
START ;START
 S %ZIS("B")="HOST FILE SERVER"
 D ^%ZIS Q:POP
 F  D  Q:$ZC=-1
 .U IO R X Q:$ZC=-1
 .S X=$TR(X,",","^")
 .S X=$TR(X,"""","")
 .U IO(0) W !,X
 .S CODE=$P(X,"^",3)
 .S CODE=+CODE
 .S ^ABMMCRV(CODE,0)=X
 D ^%ZISC
 G START
 Q
