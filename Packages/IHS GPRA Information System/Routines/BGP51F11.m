BGP51F11 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON AUG 19, 2014;
 ;;15.0;IHS CLINICAL REPORTING;;NOV 18, 2014;Build 134
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"618,49999-0024-24 ",.01)
 ;;49999-0024-24
 ;;9002226.02101,"618,49999-0024-24 ",.02)
 ;;49999-0024-24
 ;;9002226.02101,"618,49999-0024-30 ",.01)
 ;;49999-0024-30
 ;;9002226.02101,"618,49999-0024-30 ",.02)
 ;;49999-0024-30
 ;;9002226.02101,"618,49999-0024-50 ",.01)
 ;;49999-0024-50
 ;;9002226.02101,"618,49999-0024-50 ",.02)
 ;;49999-0024-50
 ;;9002226.02101,"618,49999-0024-60 ",.01)
 ;;49999-0024-60
 ;;9002226.02101,"618,49999-0024-60 ",.02)
 ;;49999-0024-60
 ;;9002226.02101,"618,49999-0024-90 ",.01)
 ;;49999-0024-90
 ;;9002226.02101,"618,49999-0024-90 ",.02)
 ;;49999-0024-90
 ;;9002226.02101,"618,49999-0035-24 ",.01)
 ;;49999-0035-24
 ;;9002226.02101,"618,49999-0035-24 ",.02)
 ;;49999-0035-24
 ;;9002226.02101,"618,49999-0035-30 ",.01)
 ;;49999-0035-30
 ;;9002226.02101,"618,49999-0035-30 ",.02)
 ;;49999-0035-30
 ;;9002226.02101,"618,49999-0035-60 ",.01)
 ;;49999-0035-60
 ;;9002226.02101,"618,49999-0035-60 ",.02)
 ;;49999-0035-60
 ;;9002226.02101,"618,49999-0036-12 ",.01)
 ;;49999-0036-12
 ;;9002226.02101,"618,49999-0036-12 ",.02)
 ;;49999-0036-12
 ;;9002226.02101,"618,49999-0036-60 ",.01)
 ;;49999-0036-60
 ;;9002226.02101,"618,49999-0036-60 ",.02)
 ;;49999-0036-60
 ;;9002226.02101,"618,49999-0090-05 ",.01)
 ;;49999-0090-05
 ;;9002226.02101,"618,49999-0090-05 ",.02)
 ;;49999-0090-05
 ;;9002226.02101,"618,49999-0090-10 ",.01)
 ;;49999-0090-10
 ;;9002226.02101,"618,49999-0090-10 ",.02)
 ;;49999-0090-10
 ;;9002226.02101,"618,49999-0090-12 ",.01)
 ;;49999-0090-12
 ;;9002226.02101,"618,49999-0090-12 ",.02)
 ;;49999-0090-12
 ;;9002226.02101,"618,49999-0090-15 ",.01)
 ;;49999-0090-15
 ;;9002226.02101,"618,49999-0090-15 ",.02)
 ;;49999-0090-15
 ;;9002226.02101,"618,49999-0090-20 ",.01)
 ;;49999-0090-20
 ;;9002226.02101,"618,49999-0090-20 ",.02)
 ;;49999-0090-20
 ;;9002226.02101,"618,49999-0090-30 ",.01)
 ;;49999-0090-30
 ;;9002226.02101,"618,49999-0090-30 ",.02)
 ;;49999-0090-30
 ;;9002226.02101,"618,49999-0090-60 ",.01)
 ;;49999-0090-60
 ;;9002226.02101,"618,49999-0090-60 ",.02)
 ;;49999-0090-60
 ;;9002226.02101,"618,49999-0090-90 ",.01)
 ;;49999-0090-90
 ;;9002226.02101,"618,49999-0090-90 ",.02)
 ;;49999-0090-90
 ;;9002226.02101,"618,49999-0091-04 ",.01)
 ;;49999-0091-04
 ;;9002226.02101,"618,49999-0091-04 ",.02)
 ;;49999-0091-04
 ;;9002226.02101,"618,49999-0091-15 ",.01)
 ;;49999-0091-15
 ;;9002226.02101,"618,49999-0091-15 ",.02)
 ;;49999-0091-15
 ;;9002226.02101,"618,49999-0091-20 ",.01)
 ;;49999-0091-20
 ;;9002226.02101,"618,49999-0091-20 ",.02)
 ;;49999-0091-20
 ;;9002226.02101,"618,49999-0091-30 ",.01)
 ;;49999-0091-30
 ;;9002226.02101,"618,49999-0091-30 ",.02)
 ;;49999-0091-30
 ;;9002226.02101,"618,49999-0091-60 ",.01)
 ;;49999-0091-60
 ;;9002226.02101,"618,49999-0091-60 ",.02)
 ;;49999-0091-60
 ;;9002226.02101,"618,49999-0152-04 ",.01)
 ;;49999-0152-04
 ;;9002226.02101,"618,49999-0152-04 ",.02)
 ;;49999-0152-04
 ;;9002226.02101,"618,49999-0262-04 ",.01)
 ;;49999-0262-04
 ;;9002226.02101,"618,49999-0262-04 ",.02)
 ;;49999-0262-04
 ;;9002226.02101,"618,49999-0314-04 ",.01)
 ;;49999-0314-04
 ;;9002226.02101,"618,49999-0314-04 ",.02)
 ;;49999-0314-04
 ;;9002226.02101,"618,49999-0326-04 ",.01)
 ;;49999-0326-04
 ;;9002226.02101,"618,49999-0326-04 ",.02)
 ;;49999-0326-04
 ;;9002226.02101,"618,49999-0339-12 ",.01)
 ;;49999-0339-12
 ;;9002226.02101,"618,49999-0339-12 ",.02)
 ;;49999-0339-12
 ;;9002226.02101,"618,49999-0340-12 ",.01)
 ;;49999-0340-12
 ;;9002226.02101,"618,49999-0340-12 ",.02)
 ;;49999-0340-12
 ;;9002226.02101,"618,49999-0493-18 ",.01)
 ;;49999-0493-18
 ;;9002226.02101,"618,49999-0493-18 ",.02)
 ;;49999-0493-18
 ;;9002226.02101,"618,49999-0594-30 ",.01)
 ;;49999-0594-30
 ;;9002226.02101,"618,49999-0594-30 ",.02)
 ;;49999-0594-30
 ;;9002226.02101,"618,49999-0594-90 ",.01)
 ;;49999-0594-90
 ;;9002226.02101,"618,49999-0594-90 ",.02)
 ;;49999-0594-90
 ;;9002226.02101,"618,49999-0657-04 ",.01)
 ;;49999-0657-04
 ;;9002226.02101,"618,49999-0657-04 ",.02)
 ;;49999-0657-04
 ;;9002226.02101,"618,49999-0701-20 ",.01)
 ;;49999-0701-20
 ;;9002226.02101,"618,49999-0701-20 ",.02)
 ;;49999-0701-20
 ;;9002226.02101,"618,49999-0701-30 ",.01)
 ;;49999-0701-30
 ;;9002226.02101,"618,49999-0701-30 ",.02)
 ;;49999-0701-30
 ;;9002226.02101,"618,49999-0721-04 ",.01)
 ;;49999-0721-04
 ;;9002226.02101,"618,49999-0721-04 ",.02)
 ;;49999-0721-04
 ;;9002226.02101,"618,49999-0768-20 ",.01)
 ;;49999-0768-20
 ;;9002226.02101,"618,49999-0768-20 ",.02)
 ;;49999-0768-20
 ;;9002226.02101,"618,49999-0768-30 ",.01)
 ;;49999-0768-30
 ;;9002226.02101,"618,49999-0768-30 ",.02)
 ;;49999-0768-30
 ;;9002226.02101,"618,49999-0902-20 ",.01)
 ;;49999-0902-20
 ;;9002226.02101,"618,49999-0902-20 ",.02)
 ;;49999-0902-20
 ;;9002226.02101,"618,49999-0902-30 ",.01)
 ;;49999-0902-30
 ;;9002226.02101,"618,49999-0902-30 ",.02)
 ;;49999-0902-30
 ;;9002226.02101,"618,50111-0307-01 ",.01)
 ;;50111-0307-01
 ;;9002226.02101,"618,50111-0307-01 ",.02)
 ;;50111-0307-01
 ;;9002226.02101,"618,50111-0307-02 ",.01)
 ;;50111-0307-02
 ;;9002226.02101,"618,50111-0307-02 ",.02)
 ;;50111-0307-02
 ;;9002226.02101,"618,50111-0307-03 ",.01)
 ;;50111-0307-03
 ;;9002226.02101,"618,50111-0307-03 ",.02)
 ;;50111-0307-03
 ;;9002226.02101,"618,50111-0308-01 ",.01)
 ;;50111-0308-01
 ;;9002226.02101,"618,50111-0308-01 ",.02)
 ;;50111-0308-01
 ;;9002226.02101,"618,50111-0308-02 ",.01)
 ;;50111-0308-02
 ;;9002226.02101,"618,50111-0308-02 ",.02)
 ;;50111-0308-02
 ;;9002226.02101,"618,50111-0308-03 ",.01)
 ;;50111-0308-03
 ;;9002226.02101,"618,50111-0308-03 ",.02)
 ;;50111-0308-03
 ;;9002226.02101,"618,50111-0309-01 ",.01)
 ;;50111-0309-01
 ;;9002226.02101,"618,50111-0309-01 ",.02)
 ;;50111-0309-01
 ;;9002226.02101,"618,50111-0309-02 ",.01)
 ;;50111-0309-02
 ;;9002226.02101,"618,50111-0309-02 ",.02)
 ;;50111-0309-02
 ;;9002226.02101,"618,50111-0309-03 ",.01)
 ;;50111-0309-03
 ;;9002226.02101,"618,50111-0309-03 ",.02)
 ;;50111-0309-03
 ;;9002226.02101,"618,50111-0393-01 ",.01)
 ;;50111-0393-01
 ;;9002226.02101,"618,50111-0393-01 ",.02)
 ;;50111-0393-01
 ;;9002226.02101,"618,50111-0394-01 ",.01)
 ;;50111-0394-01
 ;;9002226.02101,"618,50111-0394-01 ",.02)
 ;;50111-0394-01
 ;;9002226.02101,"618,50111-0394-03 ",.01)
 ;;50111-0394-03
 ;;9002226.02101,"618,50111-0394-03 ",.02)
 ;;50111-0394-03
 ;;9002226.02101,"618,50111-0395-01 ",.01)
 ;;50111-0395-01
 ;;9002226.02101,"618,50111-0395-01 ",.02)
 ;;50111-0395-01
 ;;9002226.02101,"618,50111-0395-03 ",.01)
 ;;50111-0395-03
 ;;9002226.02101,"618,50111-0395-03 ",.02)
 ;;50111-0395-03
 ;;9002226.02101,"618,50383-0796-16 ",.01)
 ;;50383-0796-16
 ;;9002226.02101,"618,50383-0796-16 ",.02)
 ;;50383-0796-16
 ;;9002226.02101,"618,50383-0801-16 ",.01)
 ;;50383-0801-16
 ;;9002226.02101,"618,50383-0801-16 ",.02)
 ;;50383-0801-16
 ;;9002226.02101,"618,50383-0803-16 ",.01)
 ;;50383-0803-16
 ;;9002226.02101,"618,50383-0803-16 ",.02)
 ;;50383-0803-16
 ;;9002226.02101,"618,50383-0804-16 ",.01)
 ;;50383-0804-16
 ;;9002226.02101,"618,50383-0804-16 ",.02)
 ;;50383-0804-16
 ;;9002226.02101,"618,50436-4379-02 ",.01)
 ;;50436-4379-02
 ;;9002226.02101,"618,50436-4379-02 ",.02)
 ;;50436-4379-02
 ;;9002226.02101,"618,50436-4379-03 ",.01)
 ;;50436-4379-03
 ;;9002226.02101,"618,50436-4379-03 ",.02)
 ;;50436-4379-03
 ;;9002226.02101,"618,50436-4379-05 ",.01)
 ;;50436-4379-05
 ;;9002226.02101,"618,50436-4379-05 ",.02)
 ;;50436-4379-05
 ;;9002226.02101,"618,50991-0320-16 ",.01)
 ;;50991-0320-16
 ;;9002226.02101,"618,50991-0320-16 ",.02)
 ;;50991-0320-16
 ;;9002226.02101,"618,50991-0405-16 ",.01)
 ;;50991-0405-16
 ;;9002226.02101,"618,50991-0405-16 ",.02)
 ;;50991-0405-16
 ;;9002226.02101,"618,50991-0528-16 ",.01)
 ;;50991-0528-16
 ;;9002226.02101,"618,50991-0528-16 ",.02)
 ;;50991-0528-16
 ;;9002226.02101,"618,50991-0790-16 ",.01)
 ;;50991-0790-16
 ;;9002226.02101,"618,50991-0790-16 ",.02)
 ;;50991-0790-16
 ;;9002226.02101,"618,51079-0066-01 ",.01)
 ;;51079-0066-01
 ;;9002226.02101,"618,51079-0066-01 ",.02)
 ;;51079-0066-01
 ;;9002226.02101,"618,51079-0066-20 ",.01)
 ;;51079-0066-20
 ;;9002226.02101,"618,51079-0066-20 ",.02)
 ;;51079-0066-20
 ;;9002226.02101,"618,51079-0077-01 ",.01)
 ;;51079-0077-01
 ;;9002226.02101,"618,51079-0077-01 ",.02)
 ;;51079-0077-01
 ;;9002226.02101,"618,51079-0077-20 ",.01)
 ;;51079-0077-20
 ;;9002226.02101,"618,51079-0077-20 ",.02)
 ;;51079-0077-20
 ;;9002226.02101,"618,51079-0078-01 ",.01)
 ;;51079-0078-01
 ;;9002226.02101,"618,51079-0078-01 ",.02)
 ;;51079-0078-01
 ;;9002226.02101,"618,51079-0078-20 ",.01)
 ;;51079-0078-20
 ;;9002226.02101,"618,51079-0078-20 ",.02)
 ;;51079-0078-20
 ;;9002226.02101,"618,51079-0221-17 ",.01)
 ;;51079-0221-17
 ;;9002226.02101,"618,51079-0221-17 ",.02)
 ;;51079-0221-17
 ;;9002226.02101,"618,51079-0221-19 ",.01)
 ;;51079-0221-19
 ;;9002226.02101,"618,51079-0221-19 ",.02)
 ;;51079-0221-19
 ;;9002226.02101,"618,51079-0404-01 ",.01)
 ;;51079-0404-01
 ;;9002226.02101,"618,51079-0404-01 ",.02)
 ;;51079-0404-01
 ;;9002226.02101,"618,51079-0404-20 ",.01)
 ;;51079-0404-20
 ;;9002226.02101,"618,51079-0404-20 ",.02)
 ;;51079-0404-20
 ;;9002226.02101,"618,51079-0406-01 ",.01)
 ;;51079-0406-01
 ;;9002226.02101,"618,51079-0406-01 ",.02)
 ;;51079-0406-01
 ;;9002226.02101,"618,51079-0406-17 ",.01)
 ;;51079-0406-17
 ;;9002226.02101,"618,51079-0406-17 ",.02)
 ;;51079-0406-17
 ;;9002226.02101,"618,51079-0406-19 ",.01)
 ;;51079-0406-19
 ;;9002226.02101,"618,51079-0406-19 ",.02)
 ;;51079-0406-19
 ;;9002226.02101,"618,51079-0406-20 ",.01)
 ;;51079-0406-20
 ;;9002226.02101,"618,51079-0406-20 ",.02)
 ;;51079-0406-20
 ;;9002226.02101,"618,51079-0796-01 ",.01)
 ;;51079-0796-01
 ;;9002226.02101,"618,51079-0796-01 ",.02)
 ;;51079-0796-01
 ;;9002226.02101,"618,51079-0796-20 ",.01)
 ;;51079-0796-20
 ;;9002226.02101,"618,51079-0796-20 ",.02)
 ;;51079-0796-20
 ;;9002226.02101,"618,51079-0806-01 ",.01)
 ;;51079-0806-01
 ;;9002226.02101,"618,51079-0806-01 ",.02)
 ;;51079-0806-01
 ;;9002226.02101,"618,51079-0806-20 ",.01)
 ;;51079-0806-20
 ;;9002226.02101,"618,51079-0806-20 ",.02)
 ;;51079-0806-20
 ;;9002226.02101,"618,51079-0816-01 ",.01)
 ;;51079-0816-01
 ;;9002226.02101,"618,51079-0816-01 ",.02)
 ;;51079-0816-01
 ;;9002226.02101,"618,51079-0816-20 ",.01)
 ;;51079-0816-20
 ;;9002226.02101,"618,51079-0816-20 ",.02)
 ;;51079-0816-20
 ;;9002226.02101,"618,51079-0895-01 ",.01)
 ;;51079-0895-01
 ;;9002226.02101,"618,51079-0895-01 ",.02)
 ;;51079-0895-01
 ;;9002226.02101,"618,51079-0895-20 ",.01)
 ;;51079-0895-20
 ;;9002226.02101,"618,51079-0895-20 ",.02)
 ;;51079-0895-20
 ;;9002226.02101,"618,51724-0052-04 ",.01)
 ;;51724-0052-04
 ;;9002226.02101,"618,51724-0052-04 ",.02)
 ;;51724-0052-04
 ;;9002226.02101,"618,51724-0214-01 ",.01)
 ;;51724-0214-01
 ;;9002226.02101,"618,51724-0214-01 ",.02)
 ;;51724-0214-01
 ;;9002226.02101,"618,51991-0333-01 ",.01)
 ;;51991-0333-01
 ;;9002226.02101,"618,51991-0333-01 ",.02)
 ;;51991-0333-01
 ;;9002226.02101,"618,51991-0334-04 ",.01)
 ;;51991-0334-04
 ;;9002226.02101,"618,51991-0334-04 ",.02)
 ;;51991-0334-04
 ;;9002226.02101,"618,51991-0334-16 ",.01)
 ;;51991-0334-16
 ;;9002226.02101,"618,51991-0334-16 ",.02)
 ;;51991-0334-16
 ;;9002226.02101,"618,51991-0838-01 ",.01)
 ;;51991-0838-01
 ;;9002226.02101,"618,51991-0838-01 ",.02)
 ;;51991-0838-01
 ;;9002226.02101,"618,51991-0838-10 ",.01)
 ;;51991-0838-10
 ;;9002226.02101,"618,51991-0838-10 ",.02)
 ;;51991-0838-10
 ;;9002226.02101,"618,52959-0043-60 ",.01)
 ;;52959-0043-60
 ;;9002226.02101,"618,52959-0043-60 ",.02)
 ;;52959-0043-60
 ;;9002226.02101,"618,52959-0053-06 ",.01)
 ;;52959-0053-06
 ;;9002226.02101,"618,52959-0053-06 ",.02)
 ;;52959-0053-06
 ;;9002226.02101,"618,52959-0053-10 ",.01)
 ;;52959-0053-10
 ;;9002226.02101,"618,52959-0053-10 ",.02)
 ;;52959-0053-10
 ;;9002226.02101,"618,52959-0053-12 ",.01)
 ;;52959-0053-12
 ;;9002226.02101,"618,52959-0053-12 ",.02)
 ;;52959-0053-12
 ;;9002226.02101,"618,52959-0053-15 ",.01)
 ;;52959-0053-15
 ;;9002226.02101,"618,52959-0053-15 ",.02)
 ;;52959-0053-15
 ;;9002226.02101,"618,52959-0053-20 ",.01)
 ;;52959-0053-20
 ;;9002226.02101,"618,52959-0053-20 ",.02)
 ;;52959-0053-20
 ;;9002226.02101,"618,52959-0053-30 ",.01)
 ;;52959-0053-30
 ;;9002226.02101,"618,52959-0053-30 ",.02)
 ;;52959-0053-30
 ;;9002226.02101,"618,52959-0053-52 ",.01)
 ;;52959-0053-52
 ;;9002226.02101,"618,52959-0053-52 ",.02)
 ;;52959-0053-52
 ;;9002226.02101,"618,52959-0074-12 ",.01)
 ;;52959-0074-12
 ;;9002226.02101,"618,52959-0074-12 ",.02)
 ;;52959-0074-12
 ;;9002226.02101,"618,52959-0074-13 ",.01)
 ;;52959-0074-13
 ;;9002226.02101,"618,52959-0074-13 ",.02)
 ;;52959-0074-13
 ;;9002226.02101,"618,52959-0074-15 ",.01)
 ;;52959-0074-15
 ;;9002226.02101,"618,52959-0074-15 ",.02)
 ;;52959-0074-15
 ;;9002226.02101,"618,52959-0074-16 ",.01)
 ;;52959-0074-16
 ;;9002226.02101,"618,52959-0074-16 ",.02)
 ;;52959-0074-16
 ;;9002226.02101,"618,52959-0074-20 ",.01)
 ;;52959-0074-20
 ;;9002226.02101,"618,52959-0074-20 ",.02)
 ;;52959-0074-20
 ;;9002226.02101,"618,52959-0074-21 ",.01)
 ;;52959-0074-21
 ;;9002226.02101,"618,52959-0074-21 ",.02)
 ;;52959-0074-21
 ;;9002226.02101,"618,52959-0074-24 ",.01)
 ;;52959-0074-24
 ;;9002226.02101,"618,52959-0074-24 ",.02)
 ;;52959-0074-24
 ;;9002226.02101,"618,52959-0074-30 ",.01)
 ;;52959-0074-30
 ;;9002226.02101,"618,52959-0074-30 ",.02)
 ;;52959-0074-30
 ;;9002226.02101,"618,52959-0074-40 ",.01)
 ;;52959-0074-40
 ;;9002226.02101,"618,52959-0074-40 ",.02)
 ;;52959-0074-40