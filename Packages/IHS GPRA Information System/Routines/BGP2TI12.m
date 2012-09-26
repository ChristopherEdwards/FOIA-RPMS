BGP2TI12 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 12, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1201,49999-0873-30 ",.01)
 ;;49999-0873-30
 ;;9002226.02101,"1201,49999-0873-30 ",.02)
 ;;49999-0873-30
 ;;9002226.02101,"1201,49999-0873-90 ",.01)
 ;;49999-0873-90
 ;;9002226.02101,"1201,49999-0873-90 ",.02)
 ;;49999-0873-90
 ;;9002226.02101,"1201,49999-0882-30 ",.01)
 ;;49999-0882-30
 ;;9002226.02101,"1201,49999-0882-30 ",.02)
 ;;49999-0882-30
 ;;9002226.02101,"1201,49999-0882-90 ",.01)
 ;;49999-0882-90
 ;;9002226.02101,"1201,49999-0882-90 ",.02)
 ;;49999-0882-90
 ;;9002226.02101,"1201,49999-0889-30 ",.01)
 ;;49999-0889-30
 ;;9002226.02101,"1201,49999-0889-30 ",.02)
 ;;49999-0889-30
 ;;9002226.02101,"1201,49999-0889-60 ",.01)
 ;;49999-0889-60
 ;;9002226.02101,"1201,49999-0889-60 ",.02)
 ;;49999-0889-60
 ;;9002226.02101,"1201,49999-0889-90 ",.01)
 ;;49999-0889-90
 ;;9002226.02101,"1201,49999-0889-90 ",.02)
 ;;49999-0889-90
 ;;9002226.02101,"1201,49999-0900-90 ",.01)
 ;;49999-0900-90
 ;;9002226.02101,"1201,49999-0900-90 ",.02)
 ;;49999-0900-90
 ;;9002226.02101,"1201,49999-0903-15 ",.01)
 ;;49999-0903-15
 ;;9002226.02101,"1201,49999-0903-15 ",.02)
 ;;49999-0903-15
 ;;9002226.02101,"1201,49999-0903-30 ",.01)
 ;;49999-0903-30
 ;;9002226.02101,"1201,49999-0903-30 ",.02)
 ;;49999-0903-30
 ;;9002226.02101,"1201,49999-0903-90 ",.01)
 ;;49999-0903-90
 ;;9002226.02101,"1201,49999-0903-90 ",.02)
 ;;49999-0903-90
 ;;9002226.02101,"1201,49999-0957-30 ",.01)
 ;;49999-0957-30
 ;;9002226.02101,"1201,49999-0957-30 ",.02)
 ;;49999-0957-30
 ;;9002226.02101,"1201,49999-0958-30 ",.01)
 ;;49999-0958-30
 ;;9002226.02101,"1201,49999-0958-30 ",.02)
 ;;49999-0958-30
 ;;9002226.02101,"1201,49999-0989-30 ",.01)
 ;;49999-0989-30
 ;;9002226.02101,"1201,49999-0989-30 ",.02)
 ;;49999-0989-30
 ;;9002226.02101,"1201,49999-0992-30 ",.01)
 ;;49999-0992-30
 ;;9002226.02101,"1201,49999-0992-30 ",.02)
 ;;49999-0992-30
 ;;9002226.02101,"1201,49999-0992-90 ",.01)
 ;;49999-0992-90
 ;;9002226.02101,"1201,49999-0992-90 ",.02)
 ;;49999-0992-90
 ;;9002226.02101,"1201,50111-0761-17 ",.01)
 ;;50111-0761-17
 ;;9002226.02101,"1201,50111-0761-17 ",.02)
 ;;50111-0761-17
 ;;9002226.02101,"1201,50111-0762-03 ",.01)
 ;;50111-0762-03
 ;;9002226.02101,"1201,50111-0762-03 ",.02)
 ;;50111-0762-03
 ;;9002226.02101,"1201,50111-0762-17 ",.01)
 ;;50111-0762-17
 ;;9002226.02101,"1201,50111-0762-17 ",.02)
 ;;50111-0762-17
 ;;9002226.02101,"1201,50111-0764-03 ",.01)
 ;;50111-0764-03
 ;;9002226.02101,"1201,50111-0764-03 ",.02)
 ;;50111-0764-03
 ;;9002226.02101,"1201,50111-0764-17 ",.01)
 ;;50111-0764-17
 ;;9002226.02101,"1201,50111-0764-17 ",.02)
 ;;50111-0764-17
 ;;9002226.02101,"1201,50742-0137-10 ",.01)
 ;;50742-0137-10
 ;;9002226.02101,"1201,50742-0137-10 ",.02)
 ;;50742-0137-10
 ;;9002226.02101,"1201,50742-0138-10 ",.01)
 ;;50742-0138-10
 ;;9002226.02101,"1201,50742-0138-10 ",.02)
 ;;50742-0138-10
 ;;9002226.02101,"1201,50742-0139-10 ",.01)
 ;;50742-0139-10
 ;;9002226.02101,"1201,50742-0139-10 ",.02)
 ;;50742-0139-10
 ;;9002226.02101,"1201,50742-0140-10 ",.01)
 ;;50742-0140-10
 ;;9002226.02101,"1201,50742-0140-10 ",.02)
 ;;50742-0140-10
 ;;9002226.02101,"1201,51079-0393-01 ",.01)
 ;;51079-0393-01
 ;;9002226.02101,"1201,51079-0393-01 ",.02)
 ;;51079-0393-01
 ;;9002226.02101,"1201,51079-0393-20 ",.01)
 ;;51079-0393-20
 ;;9002226.02101,"1201,51079-0393-20 ",.02)
 ;;51079-0393-20
 ;;9002226.02101,"1201,51079-0398-01 ",.01)
 ;;51079-0398-01
 ;;9002226.02101,"1201,51079-0398-01 ",.02)
 ;;51079-0398-01
 ;;9002226.02101,"1201,51079-0398-20 ",.01)
 ;;51079-0398-20
 ;;9002226.02101,"1201,51079-0398-20 ",.02)
 ;;51079-0398-20
 ;;9002226.02101,"1201,51079-0454-01 ",.01)
 ;;51079-0454-01
 ;;9002226.02101,"1201,51079-0454-01 ",.02)
 ;;51079-0454-01
 ;;9002226.02101,"1201,51079-0454-20 ",.01)
 ;;51079-0454-20
 ;;9002226.02101,"1201,51079-0454-20 ",.02)
 ;;51079-0454-20
 ;;9002226.02101,"1201,51079-0455-01 ",.01)
 ;;51079-0455-01
 ;;9002226.02101,"1201,51079-0455-01 ",.02)
 ;;51079-0455-01
 ;;9002226.02101,"1201,51079-0455-20 ",.01)
 ;;51079-0455-20
 ;;9002226.02101,"1201,51079-0455-20 ",.02)
 ;;51079-0455-20
 ;;9002226.02101,"1201,51079-0456-01 ",.01)
 ;;51079-0456-01
 ;;9002226.02101,"1201,51079-0456-01 ",.02)
 ;;51079-0456-01
 ;;9002226.02101,"1201,51079-0456-20 ",.01)
 ;;51079-0456-20
 ;;9002226.02101,"1201,51079-0456-20 ",.02)
 ;;51079-0456-20
 ;;9002226.02101,"1201,51079-0458-01 ",.01)
 ;;51079-0458-01
 ;;9002226.02101,"1201,51079-0458-01 ",.02)
 ;;51079-0458-01
 ;;9002226.02101,"1201,51079-0458-20 ",.01)
 ;;51079-0458-20
 ;;9002226.02101,"1201,51079-0458-20 ",.02)
 ;;51079-0458-20
 ;;9002226.02101,"1201,51079-0686-01 ",.01)
 ;;51079-0686-01
 ;;9002226.02101,"1201,51079-0686-01 ",.02)
 ;;51079-0686-01
 ;;9002226.02101,"1201,51079-0686-20 ",.01)
 ;;51079-0686-20
 ;;9002226.02101,"1201,51079-0686-20 ",.02)
 ;;51079-0686-20
 ;;9002226.02101,"1201,51079-0782-01 ",.01)
 ;;51079-0782-01
 ;;9002226.02101,"1201,51079-0782-01 ",.02)
 ;;51079-0782-01
 ;;9002226.02101,"1201,51079-0782-20 ",.01)
 ;;51079-0782-20
 ;;9002226.02101,"1201,51079-0782-20 ",.02)
 ;;51079-0782-20
 ;;9002226.02101,"1201,51079-0974-01 ",.01)
 ;;51079-0974-01
 ;;9002226.02101,"1201,51079-0974-01 ",.02)
 ;;51079-0974-01
 ;;9002226.02101,"1201,51079-0974-20 ",.01)
 ;;51079-0974-20
 ;;9002226.02101,"1201,51079-0974-20 ",.02)
 ;;51079-0974-20
 ;;9002226.02101,"1201,51079-0975-01 ",.01)
 ;;51079-0975-01
 ;;9002226.02101,"1201,51079-0975-01 ",.02)
 ;;51079-0975-01
 ;;9002226.02101,"1201,51079-0975-20 ",.01)
 ;;51079-0975-20
 ;;9002226.02101,"1201,51079-0975-20 ",.02)
 ;;51079-0975-20
 ;;9002226.02101,"1201,51079-0975-56 ",.01)
 ;;51079-0975-56
 ;;9002226.02101,"1201,51079-0975-56 ",.02)
 ;;51079-0975-56
 ;;9002226.02101,"1201,51079-0976-01 ",.01)
 ;;51079-0976-01
 ;;9002226.02101,"1201,51079-0976-01 ",.02)
 ;;51079-0976-01
 ;;9002226.02101,"1201,51079-0976-20 ",.01)
 ;;51079-0976-20
 ;;9002226.02101,"1201,51079-0976-20 ",.02)
 ;;51079-0976-20
 ;;9002226.02101,"1201,51079-0976-56 ",.01)
 ;;51079-0976-56
 ;;9002226.02101,"1201,51079-0976-56 ",.02)
 ;;51079-0976-56
 ;;9002226.02101,"1201,51138-0110-30 ",.01)
 ;;51138-0110-30
 ;;9002226.02101,"1201,51138-0110-30 ",.02)
 ;;51138-0110-30
 ;;9002226.02101,"1201,51138-0111-30 ",.01)
 ;;51138-0111-30
 ;;9002226.02101,"1201,51138-0111-30 ",.02)
 ;;51138-0111-30
 ;;9002226.02101,"1201,51138-0112-30 ",.01)
 ;;51138-0112-30
 ;;9002226.02101,"1201,51138-0112-30 ",.02)
 ;;51138-0112-30
 ;;9002226.02101,"1201,51138-0113-30 ",.01)
 ;;51138-0113-30
 ;;9002226.02101,"1201,51138-0113-30 ",.02)
 ;;51138-0113-30
 ;;9002226.02101,"1201,51138-0114-30 ",.01)
 ;;51138-0114-30
 ;;9002226.02101,"1201,51138-0114-30 ",.02)
 ;;51138-0114-30
 ;;9002226.02101,"1201,51138-0220-10 ",.01)
 ;;51138-0220-10
 ;;9002226.02101,"1201,51138-0220-10 ",.02)
 ;;51138-0220-10
 ;;9002226.02101,"1201,51138-0220-30 ",.01)
 ;;51138-0220-30
 ;;9002226.02101,"1201,51138-0220-30 ",.02)
 ;;51138-0220-30
 ;;9002226.02101,"1201,51138-0220-45 ",.01)
 ;;51138-0220-45
 ;;9002226.02101,"1201,51138-0220-45 ",.02)
 ;;51138-0220-45
 ;;9002226.02101,"1201,51138-0220-60 ",.01)
 ;;51138-0220-60
 ;;9002226.02101,"1201,51138-0220-60 ",.02)
 ;;51138-0220-60
 ;;9002226.02101,"1201,51138-0221-15 ",.01)
 ;;51138-0221-15
 ;;9002226.02101,"1201,51138-0221-15 ",.02)
 ;;51138-0221-15
 ;;9002226.02101,"1201,51138-0221-30 ",.01)
 ;;51138-0221-30
 ;;9002226.02101,"1201,51138-0221-30 ",.02)
 ;;51138-0221-30
 ;;9002226.02101,"1201,51138-0221-45 ",.01)
 ;;51138-0221-45
 ;;9002226.02101,"1201,51138-0221-45 ",.02)
 ;;51138-0221-45
 ;;9002226.02101,"1201,51138-0221-60 ",.01)
 ;;51138-0221-60
 ;;9002226.02101,"1201,51138-0221-60 ",.02)
 ;;51138-0221-60
 ;;9002226.02101,"1201,51138-0222-15 ",.01)
 ;;51138-0222-15
 ;;9002226.02101,"1201,51138-0222-15 ",.02)
 ;;51138-0222-15
 ;;9002226.02101,"1201,51138-0222-30 ",.01)
 ;;51138-0222-30
 ;;9002226.02101,"1201,51138-0222-30 ",.02)
 ;;51138-0222-30
 ;;9002226.02101,"1201,51138-0222-45 ",.01)
 ;;51138-0222-45
 ;;9002226.02101,"1201,51138-0222-45 ",.02)
 ;;51138-0222-45
 ;;9002226.02101,"1201,51138-0223-30 ",.01)
 ;;51138-0223-30
 ;;9002226.02101,"1201,51138-0223-30 ",.02)
 ;;51138-0223-30
 ;;9002226.02101,"1201,51138-0227-30 ",.01)
 ;;51138-0227-30
 ;;9002226.02101,"1201,51138-0227-30 ",.02)
 ;;51138-0227-30
 ;;9002226.02101,"1201,51138-0228-30 ",.01)
 ;;51138-0228-30
 ;;9002226.02101,"1201,51138-0228-30 ",.02)
 ;;51138-0228-30
 ;;9002226.02101,"1201,51138-0229-30 ",.01)
 ;;51138-0229-30
 ;;9002226.02101,"1201,51138-0229-30 ",.02)
 ;;51138-0229-30
 ;;9002226.02101,"1201,51138-0230-30 ",.01)
 ;;51138-0230-30
 ;;9002226.02101,"1201,51138-0230-30 ",.02)
 ;;51138-0230-30
 ;;9002226.02101,"1201,51138-0242-30 ",.01)
 ;;51138-0242-30
 ;;9002226.02101,"1201,51138-0242-30 ",.02)
 ;;51138-0242-30
 ;;9002226.02101,"1201,51138-0243-30 ",.01)
 ;;51138-0243-30
 ;;9002226.02101,"1201,51138-0243-30 ",.02)
 ;;51138-0243-30
 ;;9002226.02101,"1201,51138-0244-30 ",.01)
 ;;51138-0244-30
 ;;9002226.02101,"1201,51138-0244-30 ",.02)
 ;;51138-0244-30
 ;;9002226.02101,"1201,51138-0245-30 ",.01)
 ;;51138-0245-30
 ;;9002226.02101,"1201,51138-0245-30 ",.02)
 ;;51138-0245-30
 ;;9002226.02101,"1201,51138-0247-30 ",.01)
 ;;51138-0247-30
 ;;9002226.02101,"1201,51138-0247-30 ",.02)
 ;;51138-0247-30
 ;;9002226.02101,"1201,51138-0248-30 ",.01)
 ;;51138-0248-30
 ;;9002226.02101,"1201,51138-0248-30 ",.02)
 ;;51138-0248-30
 ;;9002226.02101,"1201,51138-0249-30 ",.01)
 ;;51138-0249-30
 ;;9002226.02101,"1201,51138-0249-30 ",.02)
 ;;51138-0249-30
 ;;9002226.02101,"1201,51138-0257-30 ",.01)
 ;;51138-0257-30
 ;;9002226.02101,"1201,51138-0257-30 ",.02)
 ;;51138-0257-30
 ;;9002226.02101,"1201,51138-0258-15 ",.01)
 ;;51138-0258-15
 ;;9002226.02101,"1201,51138-0258-15 ",.02)
 ;;51138-0258-15
 ;;9002226.02101,"1201,51138-0258-30 ",.01)
 ;;51138-0258-30
 ;;9002226.02101,"1201,51138-0258-30 ",.02)
 ;;51138-0258-30
 ;;9002226.02101,"1201,51138-0259-30 ",.01)
 ;;51138-0259-30
 ;;9002226.02101,"1201,51138-0259-30 ",.02)
 ;;51138-0259-30
 ;;9002226.02101,"1201,51138-0260-30 ",.01)
 ;;51138-0260-30
 ;;9002226.02101,"1201,51138-0260-30 ",.02)
 ;;51138-0260-30
 ;;9002226.02101,"1201,51138-0261-30 ",.01)
 ;;51138-0261-30
 ;;9002226.02101,"1201,51138-0261-30 ",.02)
 ;;51138-0261-30
 ;;9002226.02101,"1201,51138-0262-30 ",.01)
 ;;51138-0262-30
 ;;9002226.02101,"1201,51138-0262-30 ",.02)
 ;;51138-0262-30
 ;;9002226.02101,"1201,51138-0263-30 ",.01)
 ;;51138-0263-30
 ;;9002226.02101,"1201,51138-0263-30 ",.02)
 ;;51138-0263-30
 ;;9002226.02101,"1201,51138-0264-30 ",.01)
 ;;51138-0264-30
 ;;9002226.02101,"1201,51138-0264-30 ",.02)
 ;;51138-0264-30
 ;;9002226.02101,"1201,51138-0274-30 ",.01)
 ;;51138-0274-30
 ;;9002226.02101,"1201,51138-0274-30 ",.02)
 ;;51138-0274-30
 ;;9002226.02101,"1201,51138-0275-30 ",.01)
 ;;51138-0275-30
 ;;9002226.02101,"1201,51138-0275-30 ",.02)
 ;;51138-0275-30
 ;;9002226.02101,"1201,51138-0276-30 ",.01)
 ;;51138-0276-30
 ;;9002226.02101,"1201,51138-0276-30 ",.02)
 ;;51138-0276-30
 ;;9002226.02101,"1201,51138-0363-30 ",.01)
 ;;51138-0363-30
 ;;9002226.02101,"1201,51138-0363-30 ",.02)
 ;;51138-0363-30
 ;;9002226.02101,"1201,51138-0364-30 ",.01)
 ;;51138-0364-30
 ;;9002226.02101,"1201,51138-0364-30 ",.02)
 ;;51138-0364-30
 ;;9002226.02101,"1201,51138-0365-30 ",.01)
 ;;51138-0365-30
 ;;9002226.02101,"1201,51138-0365-30 ",.02)
 ;;51138-0365-30
 ;;9002226.02101,"1201,51138-0366-30 ",.01)
 ;;51138-0366-30
 ;;9002226.02101,"1201,51138-0366-30 ",.02)
 ;;51138-0366-30
 ;;9002226.02101,"1201,52959-0046-30 ",.01)
 ;;52959-0046-30
 ;;9002226.02101,"1201,52959-0046-30 ",.02)
 ;;52959-0046-30
 ;;9002226.02101,"1201,52959-0112-30 ",.01)
 ;;52959-0112-30
 ;;9002226.02101,"1201,52959-0112-30 ",.02)
 ;;52959-0112-30
 ;;9002226.02101,"1201,52959-0720-30 ",.01)
 ;;52959-0720-30
 ;;9002226.02101,"1201,52959-0720-30 ",.02)
 ;;52959-0720-30
 ;;9002226.02101,"1201,52959-0759-90 ",.01)
 ;;52959-0759-90
 ;;9002226.02101,"1201,52959-0759-90 ",.02)
 ;;52959-0759-90
 ;;9002226.02101,"1201,52959-0760-90 ",.01)
 ;;52959-0760-90
 ;;9002226.02101,"1201,52959-0760-90 ",.02)
 ;;52959-0760-90
 ;;9002226.02101,"1201,52959-0944-30 ",.01)
 ;;52959-0944-30
 ;;9002226.02101,"1201,52959-0944-30 ",.02)
 ;;52959-0944-30
 ;;9002226.02101,"1201,52959-0974-00 ",.01)
 ;;52959-0974-00
 ;;9002226.02101,"1201,52959-0974-00 ",.02)
 ;;52959-0974-00
 ;;9002226.02101,"1201,52959-0974-30 ",.01)
 ;;52959-0974-30
 ;;9002226.02101,"1201,52959-0974-30 ",.02)
 ;;52959-0974-30
 ;;9002226.02101,"1201,52959-0988-30 ",.01)
 ;;52959-0988-30
 ;;9002226.02101,"1201,52959-0988-30 ",.02)
 ;;52959-0988-30
 ;;9002226.02101,"1201,52959-0989-30 ",.01)
 ;;52959-0989-30
 ;;9002226.02101,"1201,52959-0989-30 ",.02)
 ;;52959-0989-30
 ;;9002226.02101,"1201,53002-0570-00 ",.01)
 ;;53002-0570-00
 ;;9002226.02101,"1201,53002-0570-00 ",.02)
 ;;53002-0570-00
 ;;9002226.02101,"1201,53002-0570-30 ",.01)
 ;;53002-0570-30
 ;;9002226.02101,"1201,53002-0570-30 ",.02)
 ;;53002-0570-30
 ;;9002226.02101,"1201,53002-1177-00 ",.01)
 ;;53002-1177-00
 ;;9002226.02101,"1201,53002-1177-00 ",.02)
 ;;53002-1177-00
 ;;9002226.02101,"1201,53002-1177-03 ",.01)
 ;;53002-1177-03
 ;;9002226.02101,"1201,53002-1177-03 ",.02)
 ;;53002-1177-03
 ;;9002226.02101,"1201,53002-1385-00 ",.01)
 ;;53002-1385-00
 ;;9002226.02101,"1201,53002-1385-00 ",.02)
 ;;53002-1385-00
 ;;9002226.02101,"1201,53002-1385-03 ",.01)
 ;;53002-1385-03
 ;;9002226.02101,"1201,53002-1385-03 ",.02)
 ;;53002-1385-03
 ;;9002226.02101,"1201,53002-1527-00 ",.01)
 ;;53002-1527-00
