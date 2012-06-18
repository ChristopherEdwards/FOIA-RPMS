APSBSNOD ;IHS/ITSC/ENM - INPATIENT MEDS PARAM SETUP [ 08/14/2002  2:21 PM ]
 ;;1.0;IHS INPATIENT MODIFICATIONS;;08/13/02
 ;SETUP INPATIENT AND WARD STOCK/AR NODES IN ^PS(59.7 FOR
 ;OUTPATIENT SITES LOADING THE INPATIENT SUITE OF SOFTWARE
 ;
 W !,"Now Setting up the Inpatient and Ward Stock Nodes in the Pharmacy",!,"System File!!",!!
 I '$D(DUZ) W !,?20,"Your DUZ variable is not defined!!",!,"At the programmer prompt, enter the following",!,"D ^XUP  ,enter your Access Code, press return to the prompt",!,"and then D ^APSBSNOD to run this option again!!",! Q
 S ^PS(59.7,1,20)="3.2^3020315.113218^238^^2920123^^^^^^^3020114.095216^3011004.131045",$P(^PS(59.7,1,20),"^",3)=DUZ
 S ^PS(59.7,1,59.99)="2.04^3020315^^^^3020315"
 W !,"Done!!"
 Q
