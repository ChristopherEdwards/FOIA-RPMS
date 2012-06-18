FHASM2A	; HISC/REL - Ideal Weight - Metropolitan 83 ;5/14/93  08:59
	;;5.0;Dietetics;;Oct 11, 1995
M	; Metropolitan Height & Weight tables
	; 1983 Metropolitan Life Insurance Company Height & Weight Tables
	; as measured with 1" heels and clothes weighing 5# for men and 3# for women.
M1	S OFF=$S(SEX="M":H1-61,1:H1-43),A1=$P($T(MM1+OFF),";",$F("SML",FRM)+2)
	S W1=$P(A1,"-",1),W2=$P(A1,"-",2) G:METH="M" M3
	; Ideal Weight for Spinal Cord Patients
	; Nutrition Assessment of the Spinal Cord Injured Patient by
	; Suzanne C Peiffer, R.D., Patricia Blust, R.D., and Jose Florante J Leyson
M2	W !!,"Extent of Injury:",!!?7,"P   Paraplegic",!?7,"Q   Quadriplegic"
	R !!,"Select: ",SP:DTIME I '$T!(SP["^") S IBW="^" Q
	S X=SP D TR^FHASM1 S SP=X
	I SP'="P",SP'="Q" W !?3,*7,"Only P or Q are Valid Choices" G M2
	S W1=W1-$S(SP="P":15,1:20),W2=W2-$S(SP="P":20,1:25)
M3	S W3=+$J(W1+W2/2,0,0),X1=$S(FHU'="M":W1,1:+$J(W1/2.2,0,1)),X2=$S(FHU'="M":W2,1:+$J(W2/2.2,0,1)),X3=$S(FHU'="M":W3,1:+$J(W3/2.2,0,1))
M4	W !!,"Select Ideal Weight (",X1,"-",X2,") ",X3,$S(FHU'="M":" lb",1:" kg")," // " R X:DTIME I '$T!(X["^") S IBW="^" Q
	I X="" S IBW=W3 Q
	D WGT^FHASM1 I Y<1 D WGP^FHASM1 G M4
	S IBW=+Y I IBW<W1!(IBW>W2) S METH="E"
	Q
MM1	;;62;128-134;131-141;138-150
	;;63;130-136;133-143;140-153
	;;64;132-138;135-145;142-156
	;;65;134-140;137-148;144-160
	;;66;136-142;139-151;146-164
	;;67;138-145;142-154;149-168
	;;68;140-148;145-157;152-172
	;;69;142-151;148-160;155-176
	;;70;144-154;151-163;158-180
	;;71;146-157;154-166;161-184
	;;72;149-160;157-170;164-188
	;;73;152-164;160-174;168-192
	;;74;155-168;164-178;172-197
	;;75;158-172;167-182;176-202
	;;76;162-176;171-187;181-207
MW1	;;58;102-111;109-121;118-131
	;;59;103-113;111-123;120-134
	;;60;104-115;113-126;122-137
	;;61;106-118;115-129;125-140
	;;62;108-121;118-132;128-143
	;;63;111-124;121-135;131-147
	;;64;114-127;124-138;134-151
	;;65;117-130;127-141;137-155
	;;66;120-133;130-144;140-159
	;;67;123-136;133-147;143-163
	;;68;126-139;136-150;146-167
	;;69;129-142;139-153;149-170
	;;70;132-145;142-156;152-173
	;;71;135-148;145-159;155-176
	;;72;138-151;148-162;158-179
