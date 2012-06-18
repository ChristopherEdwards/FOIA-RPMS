AUM111E ;IHS/SD/RNB - ICD 9 CODES FOR FY 2012 ; [ 09/09/2010   8:30 AM ]
 ;;12.0;TABLE MAINTENANCE;;SEP 27,2011
 ;
DRGS ;EP
 NEW AUMDA,AUMI,AUMLN,DA,DIE,DR
 F AUMI=1:1 S AUMLN=$P($T(DRG+AUMI),";;",2) Q:AUMLN="END"  D
 .S Y=$$IXDIC^AUM81("^ICD(","ILX","B","DRG"_$P(AUMLN,U),80.2,$P(AUMLN,U))
 .I Y=-1 Q
 .S DA=+Y
 .S DR=".01///DRG"_$P(AUMLN,U)       ;title
 .S DR=DR_";.06///"_$P(AUMLN,U,3)   ;surgery?
 .S DR=DR_";5///"_$P(AUMLN,U,2)     ;MDC
 .S DIE="^ICD("
 .S AUMDA=DA
 .D DIE^AUM81
 .S DA(1)=AUMDA
 .S DIC(0)="LOX"
 .S X=1
 .S DIC("P")=$P(^DD(80.2,1,0),"^",2)
 .S DIC="^ICD("_DA(1)_",1,"
 .S DIC("DR")=".01///"_$P(AUMLN,U,4)  ;description
 .D ^DIC
 Q
DRG ;;DRG^MDC^SURGERY?^DRG TITLE
 ;;END
 Q
ICD9PINA ;;ICD 9 PROCEDURE, INACTIVE CODES: CODE NUMBER(#.01)^DESCRIPTION(#10)^INACTIVE DATE(#102)
 ;;02.2^Ventriculostomy^OCT 1, 2011
 ;;END
ICD9VNEW ;;ICD 9 DIAGNOSIS, NEW V-CODES: CODE NUMBER(#.01)^DIAGNOSIS(#3)^DESCRIPTION(#10)^USE ONLY WITH SEX(#9.5)^MDC(#5)^DRG(#60-65)
 ;;V12.21^Hx gestational diabetes^Personal history of gestational diabetes^^23^951^
 ;;V12.29^Hx-endocr/meta/immun dis^Personal history of other endocrine, metabolic, and immunity disorders^^23^951^
 ;;V12.55^Hx pulmonary embolism^Personal history of pulmonary embolism^^23^951^
 ;;V13.81^Hx of anaphylaxis^Personal history of anaphylaxis^^23^951^
 ;;V13.89^Hx diseases NEC^Personal history of other specified diseases^^23^951^
 ;;V19.11^Family history glaucoma^Family history of glaucoma^^23^951^
 ;;V19.19^Family hx-eye disord NEC^Family history of other specified eye disorder^^23^951^
 ;;V23.42^Preg w hx ectopic preg^Pregnancy with history of ectopic pregnancy^F^14^998^
 ;;V23.87^Preg w incon fetl viabil^Pregnancy with inconclusive fetal viability^F^14^998^
 ;;V40.31^Wandering-dis elsewhere^Wandering in diseases classified elsewhere^^23^951^
 ;;V40.39^Oth spc behavior problem^Other specified behavioral problem^^23^951^
 ;;V54.82^Aftcr explantatn jt pros^Aftercare following explantation of joint prosthesis^^8^559,560,561^
 ;;V58.68^Lng term bisphosphonates^Long term (current) use of bisphosphonates^^23^949,950^
 ;;V87.02^Cont/susp expose uranium^Contact with and (suspected) exposure to uranium^^23^951^
 ;;V88.21^Acq absence of hip joint^Acquired absence of hip joint^^23^951^
 ;;V88.22^Acq absence knee joint^Acquired absence of knee joint^^23^951^
 ;;V88.29^Acq absence of oth joint^Acquired absence of other joint^^23^951^
 ;;END
ICD9NEW2 ;
 ;;996.88^Comp tp organ-stem cell^Complications of transplanted organ, stem cell^^21^919,920,921^1
 ;;997.32^Postproc aspiration pneu^Postprocedural aspiration pneumonia^^4^205,206^1
 ;;997.41^Ret cholelh fol cholecys^Retained cholelithiasis following cholecystectomy^^6^393,394,395^1
 ;;997.49^Oth digestv system comp^Other digestive system complications^^6^393,394,395^1
 ;;998.00^Postoperative shock, NOS^Postoperative shock, unspecified^^15^791,793^1
 ;;998.01^Postop shock,cardiogenic^Postoperative shock, cardiogenic^^15^791,793^1
 ;;998.02^Postop shock, septic^Postoperative shock, septic^^15^791,793^1
 ;;998.09^Postop shock, other^Postoperative shock, other^^15^791,793^1
 ;;999.32^Blood inf dt cen ven cth^Bloodstream infection due to central venous catheter^^5^314,315,316^1
 ;;999.33^Lcl inf dt cen ven cth^Local infection due to central venous catheter^^5^314,315,316^1
 ;;999.34^Ac inf fol trans,inf bld^Acute infection following transfusion, infusion, or injection of blood and blood products^^15^791,793^1
 ;;999.41^Anaphyl d/t adm bld/prod^Anaphylactic reaction due to administration of blood and blood products^^15^791,793^1
 ;;999.42^Anaphyl react d/t vaccin^Anaphylactic reaction due to vaccination^^15^791,793^1
 ;;999.49^Anaph react d/t ot serum^Anaphylactic reaction due to other serum^^15^791,793^1
 ;;999.51^Ot serum react d/t blood^Other serum reaction due to administration of blood and blood products^^15^791,793^1
 ;;999.52^Ot serum react d/t vacc^Other serum reaction due to vaccination^^15^791,793^1
 ;;999.59^Other serum reaction^Other serum reaction^^15^791,793^1
 ;;END
ICD9PREV ;;ICD OPERATION/PROCEDURE, REVISED CODES: CODE NUMBER(#.01)^OPERATION/PROCEDURE(#4)^DESCRIPTION(#10)^USE ONLY WITH SEX(#9.5)^MDC(#80.12)-DRG(#80.12,1-6) (Multiple MDCs/DRGs separated by "~")
 ;;00.56^Ins/rep sens-crd/vsl mtr^Insertion or replacement of implantable pressure sensor with lead for intracardiac or great vessel hemodynamic monitoring^^5-260,261,262,264^^
 ;;00.61^Perc angio extracran ves^Percutaneous angioplasty of extracranial vessel(s)^^1-34,35,36,37,38,39~5-252,253,254~21-907,908,909~24-957,958,959^^
 ;;00.62^Perc angio intracran ves^Percutaneous angioplasty of intracranial vessel(s)^^1-23,24,25,26,27~5-252,253,254~21-907,908,909~24-957,958,959^^
 ;;00.64^Perc ins extracran stent^Percutaneous insertion of other extracranial artery stent(s)^^^^
 ;;00.66^PTCA^Percutaneous transluminal coronary angioplasty [PTCA]^^5-231,232,246,247,248,249,250,251^^
 ;;02.39^Vent shunt extracran NEC^Ventricular shunt to extracranial site NEC^^1-31,32,33~17-820,821,822,826,827,828~21-907,908,909~24-957,958,959^^
 ;;13.65^After-cataract excision^Excision of secondary membrane [after cataract]^^2-116,117^^
 ;;35.20^Opn/oth rep hrt vlv NOS^Open and other replacement of unspecified heart valve^^5-216,217,218,219,220,221^^
 ;;35.21^Opn/oth rep aort vlv-tis^Open and other replacement of aortic valve with tissue graft^^5-216,217,218,219,220,221^^
 ;;35.22^Opn/oth rep aortic valve^Open and other replacement of aortic valve^^5-216,217,218,219,220,221^^
 ;;35.23^Opn/oth rep mtrl vlv-tis^Open and other replacement of mitral valve with tissue graft^^5-216,217,218,219,220,221^^
 ;;35.24^Opn/oth rep mitral valve^Open and other replacement of mitral valve^^5-216,217,218,219,220,221^^
 ;;35.25^Opn/oth rep pulm vlv-tis^Open and other replacement of pulmonary valve with tissue graft^^5-216,217,218,219,220,221^^
 ;;35.26^Opn/oth repl pul valve^Open and other replacement of pulmonary valve^^5-216,217,218,219,220,221^^
 ;;35.27^Opn/oth rep tcspd vlv-ts^Open and other replacement of tricuspid valve with tissue graft^^5-216,217,218,219,220,221^^
 ;;35.28^Opn/oth repl tcspd valve^Open and other replacement of tricuspid valve^^5-216,217,218,219,220,221^^
 ;;37.36^Exc,destrct,exclus LAA^Excision, destruction, or exclusion of left atrial appendage (LAA)^^5-250,251^^
 ;;39.50^Angio oth non-coronary^Angioplasty of other non-coronary vessel(s)^^1-37,38,39~4-166,167,168~5-252,253,254~6-356,357,358~7-423,424,425~8-515,516,517~9-579,580,581~10-628,629,630~11-673,674,675~21-907,908,909~24-957,958,959^^
 ;;39.71^Endo imp oth grf abd aor^Endovascular implantation of other graft in abdominal aorta^^5-237,238~11-673,674,675~21-907,908,909~24-957,958,959^^
 ;;39.72^Endovasc embol hd/nk ves^Endovascular (total) embolization or occlusion of head and neck vessels^^1-20,21,22,23,24,25,26,27~5-237,238~11-673,674,675~21-907,908,909~24-957,958,959^^
 ;;43.89^Opn/oth part gastrectomy^Open and other partial gastrectomy^^5-264~6-326,327,328~10-619,620,621~17-820,821,822,826,827,828~21-907,908,909~24-957,958,959^^
 ;;86.95^Ins/re pls gn no rechrg^Insertion or replacement of multiple array neurostimulator pulse generator, not specified as rechargeable^^1-23,24,29,40,41,42~8-490^^
 ;;86.98^Ins/rep mul pul gn,rechg^Insertion or replacement of multiple array (two or more) rechargeable neurostimulator pulse generator^^1-29,40,41,42~8-490^^
 ;;END
ICD9PRE2 ;;ICD OPERATION/PROCEDURE, REVISED CODES: CODE NUMBER(#.01)^OPERATION/PROCEDURE(#4)^DESCRIPTION(#10)^USE ONLY WITH SEX(#9.5)^MDC(#80.12)-DRG(#80.12,1-6) (Multiple MDCs/DRGs separated by "~")
 ;;00.55^Insert drug-elut stent(s) oth peripheral vessel(s)^Insertion of drug-eluting stent(s) of other peripheral vessel(s)^^^^
 ;;35.96^Percutaneous balloon valvuloplasty^Percutaneous balloon valvuloplasty^^5-231,232,246,247,248,249,250,251^^
 ;;37.34^Excise/destruc oth heart les or tissue, endovascul^Excision or destruction of other lesion or tissue of heart, endovascular approach^^5-246,247,248,249,250,251^^
 ;;81.02^Oth cervial fusion anterior column, anter techni^Other cervical fusion of the anterior column, anterior technique^^1-28,29,30~8-453,454,455,471,472,473~21-907,908,909~24-957,958,959^^
 ;;81.03^Oth cervical fusion posterior column, poster tech^Other cervical fusion of the posterior column, posterior technique^^1-28,29,30~8-453,454,455,471,472,473~21-907,908,909~24-957,958,959^^
 ;;81.04^Dorsal/dorsolumbar fusi anterior column, anter tec^Dorsal and dorsolumbar fusion of the anterior column, anterior technique^^1-28,29,30~8-453,454,455,456,457,458,459,460~21-907,908,909~24-957,958,959^^
 ;;81.05^Dorsal/dorsolumbar fusi posterior colum, poste tec^Dorsal and dorsolumbar fusion of the posterior column, posterior technique^^1-28,29,30~8-453,454,455,456,457,458,459,560~21-907,908,909~24-957,958,959^^
 ;;81.06^Lumbar/lumbosac fusion anterior column, anter tec^Lumbar and lumbosacral fusion of the anterior column, anterior technique^^1-28,29,30~8-453,454,455,456,457,458,459,460~21-907,908,909~24-947,958,959^^
 ;;81.07^Lumbar/lumbosac fusion posterior column, pos tech^Lumbar and lumbosacral fusion of the posterior column, posterior technique^^1-28,29,30~8-453,454,455,456,457,458,459,460~21-907,908,909~24-947,958,959^^
 ;;81.08^Lumbar/lumbosacral fusi anterior column, post tech^Lumbar and lumbosacral fusion of the anterior column, posterior technique^^1-28,29,30~8-453,454,455,456,457,458,459,460~21-907,908,909~24-947,958,959^^
 ;;81.32^Refusi oth cervica spine, anterior col, anter tec^Refusion of other cervical spine, anterior column, anterior technique^^1-28,29,30~8-453,454,455,471,472,473~21-907,908,909~24-957,958,959^^
 ;;81.33^Refus oth cervical spine, posterior col, post tech^Refusion of other cervical spine, posterior column, posterior technique^^1-28,29,30~8-453,454,455,471,472,473~21-907,908,909~24-957,958,959^^
 ;;81.34^Refusi dorsal/dorsolumb, anterior col, anter techn^Refusion of dorsal and dorsolumbar spine, anterior column, anterior technique^^1-28,29,30~8-453,454,455,456,457,458,459,460~21-907,908,909~24-947,958,959^^
 ;;81.35^Refusi dorsal/dorsolumbar, posterior col, post tec^Refusion of dorsal and dorsolumbar spine, posterior column, posterior technique^^1-28,29,30~8-453,454,455,456,457,458,459,460~21-907,908,909~24-947,958,959^^
 ;;81.36^Refusi lumbar/lumbosacral, anterior col, anter tec^Refusion of lumbar and lumbosacral spine, anterior column, anterior technique^^1-28,29,30~8-453,454,455,456,457,458,459,460~21-907,908,909~24-947,958,959^^
 ;;81.37^Refusi lumbar/lumbosacral, posterior col, post tec^Refusion of lumbar and lumbosacral spine, posterior column, posterior technique^^1-28,29,30~8-453,454,455,456,457,458,459,460~21-907,908,909~24-947,958,959^^
 ;;81.38^Refusi lumbar/lumbosacral anterior col, post tech^Refusion of lumbar and lumbosacral spine, anterior column, posterior technique^^1-28,29,30~8-453,454,455,456,457,458,459,460~21-907,908,909~24-947,958,959^^
 ;;81.80^Other total shoulder replacement^Other total shoulder replacement^^8-483,484~21-907,908,909~24-957,958,959^^
 ;;83.21^Open biopsy of soft tissue^Open biopsy of soft tissue^^1-40,41,42~4-166,167,168~08-500,501,502~9-579,580,581~16-802,803,804^^
 ;;86.11^Closed biopsy of skin and subcutaneous tissue^Closed biopsy of skin and subcutaneous tissue^^^^
 ;;88.59^Intra-operative coronary fluoresc vascul angiogra^Intra-operative coronary fluorescence vascular angiography^^^^
 ;;99.14^Injection or infusion of immunoglobulin^Injection or infusion of immunoglobulin^^^^
 ;;END
PRNT ;
 S U="^"
 W !," CODE",?10,"DIAGNOSIS",!?10,"DESCRIPTION",!," -----",?10,"-----------"
 NEW X,Y,P2,P3
 F X=1:1 S Y=$P($T(ICD9NEW+X),";;",3),P2=$P(Y,U,2),P3=$P(Y,U,3) Q:Y="END"  W !," ",$P(Y,U,1),?10,$S($L(P3):P3,1:P2),!?10,P2
 Q
