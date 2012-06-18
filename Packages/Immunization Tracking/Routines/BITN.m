BITN ;IHS/CMI/MWR - BUILD ^BITN GLOBAL.
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  UTILITY: BUILD STANDARD ^BITN GLOBAL.
 ;
 ;
 ;----------
START ;EP
 D KGBL^BIUTL8("^BITN")
 S ^BITN(0)="BI IMMUNIZATION TABLE HL7 STANDARD^9002084.94I"
 N I,X,Y,Z
 F I=1:2 S X=$T(@"TABLE"+I) Q:X'[";;"  D
 .S Y=$P(X,";;",2),Z=$P(X,";;",3)
 .S ^BITN(Y,0)=Z
 .S X=$T(@"TABLE"+(I+1)),Z=$P(X,";;",3),^BITN(Y,1)=Z
 ;
 F I=1:2 S X=$T(@"TABLE"+I^BITN2) Q:X'[";;"  D
 .S Y=$P(X,";;",2),Z=$P(X,";;",3)
 .S ^BITN(Y,0)=Z
 .S X=$T(@"TABLE"+(I+1)^BITN2),Z=$P(X,";;",3),^BITN(Y,1)=Z
 ;
 N DIK S DIK="^BITN(" D IXALL^DIK
 Q
 ;
 ;
 ;----------
TABLE ; EP
 ;;101;;SMALLPOX^SMALLPOX^75^^^^1^^12^^^^3070831^V04.1^99.42^0^1^.5^^^^
 ;;101a;;^^^^^^^^^^^^^Smallpox vaccine
 ;;102;;TD (ADULT)^Td-ADULT^9^^^^0^^8^TD-ADULT^90718^9,28,35,112,113,115,138,139,142^3081118^V06.5^99.38^0^1^.5^^^
 ;;102a;;Tetanus and Diphtheria Toxoids^54^^^^^^^^^^^^Tetanus and Diphtheria Toxoids, adsorbed for adult use
 ;;103;;DTP^DTP^1^^8^^1^^1^^90701^^^V06.1^99.39^0^1^.5^^^^
 ;;103a;;Diphtheria and Tetanus Toxoids^54^Tri-Immunol^63^^^^^^^^^^Diphtheria, tetanus toxoids and pertussis vaccine
 ;;104;;TETANUS TOXOID^TET TOX^35^^^^0^^1^^90703^9,28,35,112,113,115,138,139,142^3081118^V03.7^99.38^0^1^.5^^^
 ;;104a;;Tetanus Toxoids USP For Booste^54^Tetanus Toxoid USP^63^^^^^^^^^^Tetanus Toxoid
 ;;105;;TYPHOID, NOS^TYPH,NOS^91^^^^1^^12^^90714^^^V03.1^99.32^0^1^.5^^^
 ;;105a;;^^^^^^^^^^^^^Typhoid vaccine, NOS
 ;;106;;OPV^OPV^2^^8^^1^^2^SABIN^90712^^3000101^V04.0^99.41^1^1^.5^^^^
 ;;106a;;Orimune^63^^^^^^^^^^^^Poliovirus vaccine, live, oral
 ;;107;;IPV^IPV^10^^7^^0^^2^SALK^90713^110^3000101^V04.0^99.41^0^1^.5^^^^
 ;;107a;;IPOL^54^^^^^^^^^^^^Poliovirus vaccine, inactivated
 ;;108;;INFLUENZA, NOS^FLU,NOS^88^^^^1^^10^^90724^15,16,88,111,123,125,126,127,128,135,140,141,144^3110726^V04.8^99.52^0^1^.5^^^^
 ;;108a;;^^^^^^^^^^^^^Influenza virus vaccine, NOS
 ;;110;;HEP B, NOS^HEP B,NOS^45^^6^^1^^4^RECOMBIVAX^90731^8,43,44,51,110,104^3070718^V05.3^99.59^0^1^.5^^^^
 ;;110a;;Hepagene^56^^^^^^^^^^^^Hepatitis B vaccine, NOS
 ;;111;;MEASLES^MEASLES^5^^3^^1^^6^^90705^3,4,94^3080313^V04.2^99.45^0^1^.5^^^^
 ;;111a;;ATTENUVAX^45^^^^^^^^^^^^Measles virus vaccine
 ;;113;;CHOLERA^CHOLERA^26^^^^1^^12^^90725^^^V03.0^99.31^0^0^.5^^^^
 ;;113a;;Generic-Intramuscular^63^^^^^^^^^^^^Cholera vaccine, intramuscular
 ;;114;;RUBELLA^RUBELLA^6^^3^^1^^6^^90706^3,4,94,38^3080313^V04.3^99.47^0^1^.5^^^^
 ;;114a;;MERUVAX II^45^^^^^^^^^^^^Rubella Virus vaccine
 ;;115;;MUMPS^MUMPS^7^^3^^1^^6^^90704^7,94,38^3080313^V04.6^99.46^0^0^.5^^^^
 ;;115a;;MUMPSVAX^45^^^^^^^^^^^^Mumps Virus vaccine
 ;;116;;BCG^BCG^19^^^^1^^12^^90728^^^V03.2^99.33^1^1^.5^^^^
 ;;116a;;Tice BCG^51^Mycobax^54^^^^^^^^^^Bacillus Calmette-Guerin vaccine^90585
 ;;117;;MMR^MMR^3^^3^^0^^6^^90707^4,5,6,7,94,38^3080313^V06.4^99.48^0^1^.5^^^^
 ;;117a;;M-M-R II^45^^^^^^^^^^^^Measles, Mumps, and Rubella virus vaccine
 ;;118;;M/R^MR^4^^3^^1^^6^^90708^3,5,6,94,38^3080313^V04.2^99.59^0^1^.5^^^^
 ;;118a;;M-R-VAX II^45^^^^^^^^^^^^Measles and Rubella virus vaccine
 ;;119;;PNEUMOCOCCAL^PNEUMO-PS^33^^^^0^^11^^90732^100,109^3091006^V03.82^99.55^0^1^.5^^^^
 ;;119a;;PNEUMOVAX 23^45^PNU-IMUNE 23^63^^^^^^^^^^Pneumococcal polysaccharide vaccine
 ;;120;;YELLOW FEVER^YELLOW FEV^37^^^^0^^12^^90717^^3110330^V04.4^99.43^0^1^.5^^^
 ;;120a;;YF-VAX^54^^^^^^^^^^^^Yellow Fever Vaccine
 ;;122;;RABIES, NOS^RABIES,NOS^90^^^^1^^12^^90726^^^V04.5^99.44^0^1^.5^^^^
 ;;122a;;^^^^^^^^^^^^^Rabies vaccine, NOS
 ;;123;;DT (PEDIATRIC)^DT-PEDS^28^^8^^0^^1^^90702^9,28,35,112,113,115,138,139,142^3070517^V06.5^99.38^0^1^.5^^^^
 ;;123a;;Diphtheria and Tetanus Toxoids^40^^^^^^^^^^^^Diphtheria and tetanus toxoids adsorbed for pediatric use
 ;;124;;HIB, NOS^HIB,NOS^17^^6^^1^^3^^90737^46,47,48,49,51,110^^V03.81^99.59^0^1^.5^^^^
 ;;124a;;^^^^^^^^^^^^^Haemophilus influenza type b vaccine, conjugate NOS
 ;;126;;HIB (HBOC)^HIBTITER^47^^6^^0^^3^HIB,HBOC^90645^17,46,48,49^3080918^V03.81^99.59^0^1^.5^^^^
 ;;126a;;HibTITER^63^^^^^^^^^^^^Haemophilus influenza type b vaccine, HbOC
 ;;127;;HIB (PRP-OMP)^PEDVAXHIB^49^^5^^0^^3^HIB,PRPOMP^90647^17,46,47,48,51^3080918^V03.81^99.59^0^1^.5^^^^
 ;;127a;;PedvaxHIB^45^^^^^^^^^^^^Haemophilus influenza type b vaccine, PRP-OMP conjugate
 ;;128;;HIB (PRP-D)^PROHIBIT^46^^6^^1^^3^HIB,PRP-D^90646^17,47,48,49^2981216^V03.81^99.59^0^0^.5^^^^
 ;;128a;;ProHIBiT^54^^^^^^^^^^^^Haemophilus influenza type b vaccine, PRP-D conjugate
 ;;129;;HBIG^HBIG^30^^^^0^^5^^90371^^^V07.2^99.14^0^1^^^^^
 ;;129a;;Hepatitis B Immune Globulin (H^19^^^^^^^^^^^^Hepatitis B immune globulin
 ;;130;;IG, NOS^IG,NOS^14^^^^1^^12^^90741^^^V07.2^99.14^0^0^^^^^
 ;;130a;;^^^^^^^^^^^^^Immune globulin, NOS
 ;;131;;HEP A, NOS^HEP A,NOS^85^^3^^1^^9^^90730^52,83,84,31,104^^V05.3^99.59^0^1^.5^^^^^
 ;;131a;;^^^^^^^^^^^^^Hepatitis A vaccine, NOS
 ;;132;;VARICELLA^VARICELLA^21^^3^^0^^7^^90716^94,121^3080313^V05.4^99.59^0^1^.5^^^
 ;;132a;;VARIVAX^45^^^^^^^^^^^^Varicella virus vaccine
 ;;133;;DTAP^DTaP^20^^6^^0^^1^DTAP^90700^106,107,110,50^3080918^V06.1^99.39^0^1^.5^^^^
 ;;133a;;Tripedia^54^Infanrix^59^Acel-Imune^63^Certiva^24^^^^^^Diphtheria, tetanus toxoids and acellular pertussis vaccine
 ;;134;;MENINGOCOCCAL^MENING-PS^32^^^^0^^16^^90733^103,108,114^3111014^V03.89^99.59^0^1^.5^^^^
 ;;134a;;Menomume A/C/Y/W-135^54^^^^^^^^^^^^Meningococcal polysaccharide vaccine
 ;;135;;ROTAVIRUS TETRAVALENT^ROTA-4^74^^4^^1^^15^^^116,119,122^^V04.89^99.59^1^1^.5^^^^
 ;;135a;;ROTASHIELD^63^^^^^^^^^^^^Rotavirus vaccine, tetravalent, live, oral
 ;;136;;HIB (PRP-T)^ACTHIB^48^^6^^0^^3^HIB,PRP-T^90648^17,46,47,49^3080918^V03.81^99.59^0^1^.5^^^
 ;;136a;;ActHIB^54^OmniHIB^59^Hiberix^^^^^^^^^Haemophilus influenza type b vaccine, PRP-T conjugate
 ;;137;;UNKNOWN^OTHER^999^^^^1^^12^TEST^90749^^^^99.59^0^0^.5^^^
 ;;137a;;^^^^^^^^^^^^^Unknown vaccine or immune globulin
 ;;138;;HEP B, ADOLESCENT OR PEDIATRIC^HEP B PED^8^^6^^0^^4^^90744^43,44,45,51,110,42,104^3070718^V05.3^99.59^0^1^.5^^^
 ;;138a;;Recombivax HB pediatric formul^45^Engerix-B pediatric/adolescent^59^^^^^^^^^^Hepatitis B vaccine, pediatric or pediatric/adolescent dosage
 ;;139;;POLIO, NOS^POLIO,NOS^89^^^^1^^2^^^^^V04.0^99.41^0^1^.5^^^
 ;;139a;;^^^^^^^^^^^^^Polio, NOS
 ;;140;;LYME DISEASE^LYME^66^^^^1^^12^^90665^^^V03.89^99.59^1^1^.5^^^
 ;;140a;;LYMErix^59^^^^^^^^^^^^Lyme Disease Vaccine
 ;;141;;RSV-MAB^RSV-MAb^93^^^^0^^12^SYNAGIS^90378^71,93,145^^V07.2^99.14^0^1^^^^
 ;;141a;;Synagis^42^^^^^^^^^^^^Respiratory Syncytial virus monoclanal antibody (palivizumab), intramuscular
 ;;142;;Pneumococcal, PCV-7^PCV-7^100^^6^^1^^11^PCV7^90669^109,133^3080918^V03.82^99.55^0^1^.5^^^
 ;;142a;;Prevnar 7^63^PREVNAR 7^^^^^^^^^^^pneumococcal conjugate vaccine, 7 valent
 ;;143;;MENINGOCOCCAL C CONJUGATE^MEN-C CONJ^103^^^^1^^16^^^32,108,114^^V03.89^99.59^0^1^.5^^^
 ;;143a;;^^^^^^^^^^^^^Meningococcal C conjugate vaccine
 ;;144;;HEP B,ADULT^HEP B ADLT^43^^6^^0^^4^^90746^8,42,44,45,104^3070718^V05.3^99.59^0^1^1^^^
 ;;144a;;Recombivax HB adult formulatio^45^Heptavax-B^45^Engerix-B adult dose^59^^^^^^^^Hepatitis B vaccine, adult dosage^90743
 ;;145;;PERTUSSIS^PERTUSSIS^11^^^^1^^^^^^^^^0^0^.5
 ;;145a;;^^^^^^^^^^^^^Pertussis
 ;;146;;DIPHTHERIA ANTITOXIN^DIPHTHERIA^12^^^^1^^^^90296^^^^^0^1^.5^^
 ;;146a;;Diphtheria antitoxin^^^^^^^^^^^^^Diphtheria antitoxin
 ;;147;;TIG^TIG^13^^^^0^^^^90389^^^^^0^1^
 ;;147a;;^^^^^^^^^^^^^Tetanus immune globulin
 ;;148;;INFLUENZA, SPLIT [TIVhx] (INCL PURIFIED)^FLU-TIVhx^15^^^^1^^10^^90657^15,16,88,111,123,125,126,127,128,135,140,141,144^3110726^^^0^1^.5
 ;;148a;;FLUVIRIN split-virus 1998-1999^32^Fluogen 1998-1999 formula^53^FluShield 1998-1999 formula^63^Fluzone-split^^FLU-SPLIT^^^^^Influenza virus vaccine, split virus (incl. Purified surface antigen)^90658
 ;;149;;INFLUENZA, WHOLE^FLU-WHOLE^16^^^^1^^10^^90659^15,16,88,111,123,125,126,127,128,135,140,141,144^^^^0^1^.5
 ;;149a;;^54^^^^^^^^^^^^Influenza virus vaccine, whole virus
 ;;150;;RABIES, INTRAMUSCULAR INJECTION^RABIES,IM^18^^^^0^^^^90675^^3091006^^^0^1^.5
 ;;150a;;RabAvert^29^Imovax Rabies^54^Rabies Vaccine Absorbed^44^^^^^^^^Rabies vaccine - for intramuscular injection
 ;;151;;DTP-HIB^DTP-HIB^22^^^^1^^^^90720^^^^^0^1^.5^^^103^126
 ;;151a;;ActHIB/DTP^54^Tetramune^63^^^^^^^^^^DTP-Haemophilus influenza type b conjugate vaccine
 ;;152;;PLAGUE^PLAGUE^23^^^^1^^^^90727^^^^^0^0^.5
 ;;152a;;^^^^^^^^^^^^^Plague
 ;;153;;ANTHRAX^ANTHRAX^24^^^^1^^^^90581^^3100310^^^0^1^.5^^
 ;;153a;;Biothrax^44^^^^^^^^^^^^Anthrax vaccine
 ;;154;;TYPHOID, ORAL^TYPHOID,OR^25^^^^0^^^^90690^^3040519^^^0^1^.5
 ;;154a;;Vivotif Berna^27^^^^^^^^^^^^Typhoid vaccine, live, oral
 ;;155;;BOTULINUM ANTITOXIN^BOTULINUM^27^^^^1^^^^90287^^^^^0^1^.5^^
 ;;155a;;Botox^17^^^^^^^^^^^^Botulinum antitoxin
 ;;156;;CMVIG^CMVIG^29^^^^0^^^^90291^^^^^0^1^.5^^
 ;;156a;;CytoGam^40^^^^^^^^^^^^Cytomegalovirus immune globulin, intravenous
 ;;157;;HEP A, PEDIATRIC, NOS^HEP AP,NOS^31^^^^1^^9^^^83,84,85,52,104^^^^0^1^.5^^
 ;;157a;;^^^^^^^^^^^^^Hepatitis A vaccine, pediatric dosage NOS
 ;;158;;RIG^RIG^34^^^^0^^^^90376^^^^^0^0^.5
 ;;158a;;BayRab^25^IMOGRAM RABIES - HT^54^^^^^^^^^^Rabies immune globulin^90375
 ;;159;;VZIG^VZIG^36^^^^1^^^^90396^117^^^^0^0^
 ;;159a;;^^^^^^^^^^^^^Varicella zoster immune globulin
 ;;160;;RUBELLA/MUMPS^RUBELLA/MU^38^^^^1^^^^^6,3,4,94^3080313^^^0^0^.5
 ;;160a;;BIAVAX II^45^^^^^^^^^^^^Rubella and Mumps virus vaccine
 ;;161;;JAPANESE ENCEPHALITIS^JAPANESE E^39^^^^1^^^^90735^^3100301^^^0^1^.5
 ;;161a;;JE-VAX^54^^^^^^^^^^^^Japanese Encephalitis virus vaccine
 ;;162;;RABIES, INTRADERMAL INJECTION^RABIES,ID^40^^^^0^^^^90676^^3091006^^^0^1^.5
 ;;162a;;Imovax Rabies I.D.^54^^^^^^^^^^^^Rabies vaccine, for intradermal injection
 ;;163;;TYPHOID, PARENTERAL^TYPHOID,PA^41^^^^0^^^^90692^^3040519^^^0^1^.5
 ;;163a;;Typhim Vi^54^^^^^^^^^^^^Typhoid vaccine, Parenteral; other than acetone killed, dried
 ;;164;;HEP B, ADOLESCENT/HIGH RISK INFA^HEP B ADOL^42^^^^1^^4^^90745^43,44,45,8,104^3070718^^^0^1^.5
 ;;164a;;Recombivax HB adolescent/high-^45^^^^^^^^^^^^Hepatitis B vaccine, adolescent/high risk infant dosage
 ;;165;;HEP B, DIALYSIS^HEP B DIAL^44^^^^1^^4^^90740^8,43,45,42,104^3070718^^^0^1^1
 ;;165a;;^^^^^^^^^^^^^Hepatitis B vaccine, dialysis patient dosage^90747
 ;;166;;DTAP-HIB^DTAP-HIB^50^^^^1^^14^^90721^20,106,107,110,46,47,48,49,17,51,120^3080918^^^0^1^.5^^^133^136
 ;;166a;;TriHIBit^54^^^^^^^^^^^^DTaP-Haemophilus influenza type b conjugate vaccine
 ;;167;;HIB-HEP B^COMVAX^51^^^^0^^14^^90748^46,47,48,8,42,43,44,45,49,17^3080918^^^0^1^.5^^^138^127
 ;;167a;;Comvax^45^^^^^^^^^^^^Haemophilus influenza type b vaccine conjugate and Hepatitis B vaccine
 ;;168;;HEP A, ADULT^HEP A ADLT^52^^^^0^^9^^90632^83,84,31,104,85^3060321^^^0^1^1
 ;;168a;;VAQTA adult formulation^45^Havrix 1440 ELU/1 mL^59^^^^^^^^^^Hepatitis A vaccine, adult dosage
 ;;169;;TYPHOID, PARENTERAL, AKD (U.S. M^TYPHOID,PM^53^^^^0^^^^90693^^3040519^^^0^1^.5
 ;;169a;;^^^^^^^^^^^^^Typhoid vaccine, Parenteral; acetone killed, dried (U.S. military)
 ;;170;;ADENOVIRUS, TYPE 4^ADENOVI,T4^54^^^^1^^^^90476^54,55,82,143^^^^0^0^.5
 ;;170a;;^^^^^^^^^^^^^Adenovirus vaccine, type 4, live, oral
 ;;171;;ADENOVIRUS, TYPE 7^ADENOVI,T7^55^^^^1^^^^90477^54,55,82,143^^^^0^0^.5^^
 ;;171a;;^^^^^^^^^^^^^Adenovirus vaccine, type 7, live, oral
 ;;172;;DENGUE FEVER^DENGUE FEV^56^^^^1^^^^^^^^^0^0^.5^^
 ;;172a;;^^^^^^^^^^^^^Dengue fever vaccine
 ;;173;;HANTAVIRUS^HANTAVIRUS^57^^^^1^^^^^^^^^0^0^.5^^
 ;;173a;;^^^^^^^^^^^^^Hantavirus vaccine
 ;;174;;HEP C^HEP C^58^^^^1^^^^^^^^^0^0^.5
 ;;174a;;^^^^^^^^^^^^^Hepatitis C vaccine
 ;;175;;HEP E^HEP E^59^^^^1^^^^^^^^^0^0^.5
 ;;175a;;^^^^^^^^^^^^^Hepatitis E vaccine
 ;;176;;HERPES SIMPLEX 2^HERPES SIM^60^^^^1^^^^^^^^^0^0^.5
 ;;176a;;^^^^^^^^^^^^^Herpes simples virus, type 2 vaccine
 ;;177;;HIV^HIV^61^^^^1^^^^^^^^^0^0^.5
 ;;177a;;^^^^^^^^^^^^^Human immunodeficiency virus vaccine
 ;;178;;HPV QUADRIVALENT^HPV-4^62^^^^0^^17^^90649^62,118,137^3110503^^^0^1^.5
 ;;178a;;Gardasil^^^^^^^^^^^^^Human papilloma virus vaccine
 ;;179;;JUNIN VIRUS^JUNIN VIRU^63^^^^1^^^^^^^^^0^0^.5
 ;;179a;;^^^^^^^^^^^^^Junin virus vaccine
 ;;180;;LEISHMANIASIS^LEISHMANIA^64^^^^1^^^^^^^^^0^0^.5
 ;;180a;;^^^^^^^^^^^^^Leishmaniasis vaccine
 ;;181;;LEPROSY^LEPROSY^65^^^^1^^^^^^^^^0^0^.5
 ;;181a;;^^^^^^^^^^^^^Leprosy vaccine
 ;;182;;MALARIA^MALARIA^67^^^^1^^^^^^^^^0^0^.5
 ;;182a;;^^^^^^^^^^^^^Malaria vaccine
 ;;183;;MELANOMA^MELANOMA^68^^^^1^^^^^^^^^0^0^.5
 ;;183a;;^^^^^^^^^^^^^Melanoma vaccine
 ;;184;;PARAINFLUENZA-3^PARAINFLUE^69^^^^1^^^^^^^^^0^0^.5
 ;;184a;;^^^^^^^^^^^^^Parinfluenza - 3 virus vaccine
 ;;185;;Q FEVER^Q FEVER^70^^^^1^^^^^^^^^0^0^.5
 ;;185a;;^^^^^^^^^^^^^Q Fever vaccine
 ;;186;;RSV-IGIV ^RSV-IGIV ^71^^^^1^^^^90379^71,93,145^^^^0^1^
 ;;186a;;RespiGam^42^^^^^^^^^^^^Respiratory Syncytial virus immune globulin, intravenous
 ;;187;;RHEUMATIC FEVER^RHEUMATIC ^72^^^^1^^^^^^^^^0^0^.5
 ;;187a;;^^^^^^^^^^^^^Rheumatic fever vaccine
 ;;188;;RIFT VALLEY FEVER^RIFT VALLE^73^^^^1^^^^^^^^^0^0^.5
 ;;188a;;^^^^^^^^^^^^^Rift Valley Fever vaccine
 ;;189;;STAPHYLOCOCCUS BACTERIO LYSATE^STAPHYLOCO^76^^^^1^^^^^^^^^0^0^.5
 ;;189a;;^^^^^^^^^^^^^Staphylococcus Bacterophage lysate
 ;;190;;TICK-BORNE ENCEPHALITIS^TICK-BORNE^77^^^^1^^^^^^^^^0^0^.5
 ;;190a;;^^^^^^^^^^^^^Tick-borne enchephalitis vaccine
 ;;191;;TULAREMIA VACCINE^TULAREMIA ^78^^^^1^^^^^^^^^0^0^.5
 ;;191a;;^^^^^^^^^^^^^Tularemia vaccine
 ;;192;;VACCINIA IMMUNE GLOBULIN^VACCINIA I^79^^^^0^^^^90393^^3070831^^^0^0^.5
 ;;192a;;^^^^^^^^^^^^^Vaccinia immune globulin
 ;;193;;VEE, LIVE^VEE, LIVE^80^^^^1^^^^^^^^^0^0^.5
 ;;193a;;^^^^^^^^^^^^^Venezuelan equine enchapahlitis vaccine, live, attenuated
 ;;194;;VEE, INACTIVATED^VEE, INACT^81^^^^1^^^^^^^^^0^0^.5
 ;;194a;;^^^^^^^^^^^^^Venezuelan equine enchapahlitis vaccine, inactivated
 ;;195;;ADENOVIRUS, NOS^ADENOV,NOS^82^^^^1^^^^^54,55,82,143^^^^0^0^.5^^
 ;;195a;;^^^^^^^^^^^^^Adenovirus vaccine, NOS
 ;;196;;HEP A, PED/ADOL, 2 DOSE^HEP A PED^83^^^^0^^9^^90633^52,84,31,85,104^3060321^^^0^1^.5^^
 ;;196a;;VAQTA pediatric/adolescent for^45^Havrix 720 ELU/0.5 mL^59^^^^^^^^^^Hepatitis A vaccine, pediatric/adolescent dosage, 2 dose schedule
 ;;197;;HEP A, PED/ADOL, 3 DOSE^HEP A 3PED^84^^^^1^^9^^90634^52,83,31,85,104^3060321^^^0^1^.5^^
 ;;197a;;Havrix 360 ELU/0.5 mL^59^^^^^^^^^^^^Hepatitis A vaccine, pediatric/adolescent dosage, 3 dose schedule
 ;;198;;IG^IG^86^^^^^^^^90281^^^^^0^0^
 ;;198a;;^^^^^^^^^^^^^Immune globulin, intramuscular
 ;;199;;IGIV^IGIV^87^^^^0^^^^90283^^^^^0^0^
 ;;199a;;Gammar-P IV^21^Venoglobulin-S^19^^^^^^^^^^Immune globulin, intravenous
