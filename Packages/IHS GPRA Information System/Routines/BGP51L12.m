BGP51L12 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON AUG 19, 2014;
 ;;15.0;IHS CLINICAL REPORTING;;NOV 18, 2014;Build 134
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"806,63874-0357-14 ",.02)
 ;;63874-0357-14
 ;;9002226.02101,"806,63874-0357-15 ",.01)
 ;;63874-0357-15
 ;;9002226.02101,"806,63874-0357-15 ",.02)
 ;;63874-0357-15
 ;;9002226.02101,"806,63874-0357-20 ",.01)
 ;;63874-0357-20
 ;;9002226.02101,"806,63874-0357-20 ",.02)
 ;;63874-0357-20
 ;;9002226.02101,"806,63874-0357-21 ",.01)
 ;;63874-0357-21
 ;;9002226.02101,"806,63874-0357-21 ",.02)
 ;;63874-0357-21
 ;;9002226.02101,"806,63874-0357-24 ",.01)
 ;;63874-0357-24
 ;;9002226.02101,"806,63874-0357-24 ",.02)
 ;;63874-0357-24
 ;;9002226.02101,"806,63874-0357-30 ",.01)
 ;;63874-0357-30
 ;;9002226.02101,"806,63874-0357-30 ",.02)
 ;;63874-0357-30
 ;;9002226.02101,"806,63874-0357-40 ",.01)
 ;;63874-0357-40
 ;;9002226.02101,"806,63874-0357-40 ",.02)
 ;;63874-0357-40
 ;;9002226.02101,"806,63874-0357-60 ",.01)
 ;;63874-0357-60
 ;;9002226.02101,"806,63874-0357-60 ",.02)
 ;;63874-0357-60
 ;;9002226.02101,"806,63874-0588-01 ",.01)
 ;;63874-0588-01
 ;;9002226.02101,"806,63874-0588-01 ",.02)
 ;;63874-0588-01
 ;;9002226.02101,"806,63874-0588-04 ",.01)
 ;;63874-0588-04
 ;;9002226.02101,"806,63874-0588-04 ",.02)
 ;;63874-0588-04
 ;;9002226.02101,"806,63874-0588-10 ",.01)
 ;;63874-0588-10
 ;;9002226.02101,"806,63874-0588-10 ",.02)
 ;;63874-0588-10
 ;;9002226.02101,"806,63874-0588-14 ",.01)
 ;;63874-0588-14
 ;;9002226.02101,"806,63874-0588-14 ",.02)
 ;;63874-0588-14
 ;;9002226.02101,"806,63874-0588-20 ",.01)
 ;;63874-0588-20
 ;;9002226.02101,"806,63874-0588-20 ",.02)
 ;;63874-0588-20
 ;;9002226.02101,"806,63874-0588-30 ",.01)
 ;;63874-0588-30
 ;;9002226.02101,"806,63874-0588-30 ",.02)
 ;;63874-0588-30
 ;;9002226.02101,"806,63874-0588-60 ",.01)
 ;;63874-0588-60
 ;;9002226.02101,"806,63874-0588-60 ",.02)
 ;;63874-0588-60
 ;;9002226.02101,"806,63874-0588-80 ",.01)
 ;;63874-0588-80
 ;;9002226.02101,"806,63874-0588-80 ",.02)
 ;;63874-0588-80
 ;;9002226.02101,"806,63874-0588-90 ",.01)
 ;;63874-0588-90
 ;;9002226.02101,"806,63874-0588-90 ",.02)
 ;;63874-0588-90
 ;;9002226.02101,"806,63874-0665-01 ",.01)
 ;;63874-0665-01
 ;;9002226.02101,"806,63874-0665-01 ",.02)
 ;;63874-0665-01
 ;;9002226.02101,"806,63874-0665-04 ",.01)
 ;;63874-0665-04
 ;;9002226.02101,"806,63874-0665-04 ",.02)
 ;;63874-0665-04
 ;;9002226.02101,"806,63874-0665-10 ",.01)
 ;;63874-0665-10
 ;;9002226.02101,"806,63874-0665-10 ",.02)
 ;;63874-0665-10
 ;;9002226.02101,"806,63874-0665-14 ",.01)
 ;;63874-0665-14
 ;;9002226.02101,"806,63874-0665-14 ",.02)
 ;;63874-0665-14
 ;;9002226.02101,"806,63874-0665-30 ",.01)
 ;;63874-0665-30
 ;;9002226.02101,"806,63874-0665-30 ",.02)
 ;;63874-0665-30
 ;;9002226.02101,"806,63874-0665-60 ",.01)
 ;;63874-0665-60
 ;;9002226.02101,"806,63874-0665-60 ",.02)
 ;;63874-0665-60
 ;;9002226.02101,"806,63874-0665-90 ",.01)
 ;;63874-0665-90
 ;;9002226.02101,"806,63874-0665-90 ",.02)
 ;;63874-0665-90
 ;;9002226.02101,"806,64011-0215-41 ",.01)
 ;;64011-0215-41
 ;;9002226.02101,"806,64011-0215-41 ",.02)
 ;;64011-0215-41
 ;;9002226.02101,"806,64248-0101-01 ",.01)
 ;;64248-0101-01
 ;;9002226.02101,"806,64248-0101-01 ",.02)
 ;;64248-0101-01
 ;;9002226.02101,"806,64248-0102-01 ",.01)
 ;;64248-0102-01
 ;;9002226.02101,"806,64248-0102-01 ",.02)
 ;;64248-0102-01
 ;;9002226.02101,"806,64720-0123-10 ",.01)
 ;;64720-0123-10
 ;;9002226.02101,"806,64720-0123-10 ",.02)
 ;;64720-0123-10
 ;;9002226.02101,"806,64720-0124-10 ",.01)
 ;;64720-0124-10
 ;;9002226.02101,"806,64720-0124-10 ",.02)
 ;;64720-0124-10
 ;;9002226.02101,"806,64720-0125-10 ",.01)
 ;;64720-0125-10
 ;;9002226.02101,"806,64720-0125-10 ",.02)
 ;;64720-0125-10
 ;;9002226.02101,"806,64720-0125-11 ",.01)
 ;;64720-0125-11
 ;;9002226.02101,"806,64720-0125-11 ",.02)
 ;;64720-0125-11
 ;;9002226.02101,"806,64727-3298-01 ",.01)
 ;;64727-3298-01
 ;;9002226.02101,"806,64727-3298-01 ",.02)
 ;;64727-3298-01
 ;;9002226.02101,"806,64727-3298-02 ",.01)
 ;;64727-3298-02
 ;;9002226.02101,"806,64727-3298-02 ",.02)
 ;;64727-3298-02
 ;;9002226.02101,"806,64727-3299-01 ",.01)
 ;;64727-3299-01
 ;;9002226.02101,"806,64727-3299-01 ",.02)
 ;;64727-3299-01
 ;;9002226.02101,"806,64727-3299-02 ",.01)
 ;;64727-3299-02
 ;;9002226.02101,"806,64727-3299-02 ",.02)
 ;;64727-3299-02
 ;;9002226.02101,"806,64727-3300-01 ",.01)
 ;;64727-3300-01
 ;;9002226.02101,"806,64727-3300-01 ",.02)
 ;;64727-3300-01
 ;;9002226.02101,"806,64727-3300-02 ",.01)
 ;;64727-3300-02
 ;;9002226.02101,"806,64727-3300-02 ",.02)
 ;;64727-3300-02
 ;;9002226.02101,"806,64727-3302-01 ",.01)
 ;;64727-3302-01
 ;;9002226.02101,"806,64727-3302-01 ",.02)
 ;;64727-3302-01
 ;;9002226.02101,"806,64727-3302-02 ",.01)
 ;;64727-3302-02
 ;;9002226.02101,"806,64727-3302-02 ",.02)
 ;;64727-3302-02
 ;;9002226.02101,"806,64727-3303-01 ",.01)
 ;;64727-3303-01
 ;;9002226.02101,"806,64727-3303-01 ",.02)
 ;;64727-3303-01
 ;;9002226.02101,"806,64727-3303-02 ",.01)
 ;;64727-3303-02
 ;;9002226.02101,"806,64727-3303-02 ",.02)
 ;;64727-3303-02
 ;;9002226.02101,"806,64727-3305-01 ",.01)
 ;;64727-3305-01
 ;;9002226.02101,"806,64727-3305-01 ",.02)
 ;;64727-3305-01
 ;;9002226.02101,"806,64727-3305-02 ",.01)
 ;;64727-3305-02
 ;;9002226.02101,"806,64727-3305-02 ",.02)
 ;;64727-3305-02
 ;;9002226.02101,"806,64727-3307-01 ",.01)
 ;;64727-3307-01
 ;;9002226.02101,"806,64727-3307-01 ",.02)
 ;;64727-3307-01
 ;;9002226.02101,"806,64727-3307-02 ",.01)
 ;;64727-3307-02
 ;;9002226.02101,"806,64727-3307-02 ",.02)
 ;;64727-3307-02
 ;;9002226.02101,"806,64727-3308-01 ",.01)
 ;;64727-3308-01
 ;;9002226.02101,"806,64727-3308-01 ",.02)
 ;;64727-3308-01
 ;;9002226.02101,"806,64727-3308-02 ",.01)
 ;;64727-3308-02
 ;;9002226.02101,"806,64727-3308-02 ",.02)
 ;;64727-3308-02
 ;;9002226.02101,"806,64727-3309-01 ",.01)
 ;;64727-3309-01
 ;;9002226.02101,"806,64727-3309-01 ",.02)
 ;;64727-3309-01
 ;;9002226.02101,"806,64727-3309-02 ",.01)
 ;;64727-3309-02
 ;;9002226.02101,"806,64727-3309-02 ",.02)
 ;;64727-3309-02
 ;;9002226.02101,"806,64727-3310-01 ",.01)
 ;;64727-3310-01
 ;;9002226.02101,"806,64727-3310-01 ",.02)
 ;;64727-3310-01
 ;;9002226.02101,"806,64727-3310-02 ",.01)
 ;;64727-3310-02
 ;;9002226.02101,"806,64727-3310-02 ",.02)
 ;;64727-3310-02
 ;;9002226.02101,"806,64727-3312-01 ",.01)
 ;;64727-3312-01
 ;;9002226.02101,"806,64727-3312-01 ",.02)
 ;;64727-3312-01
 ;;9002226.02101,"806,64727-3312-02 ",.01)
 ;;64727-3312-02
 ;;9002226.02101,"806,64727-3312-02 ",.02)
 ;;64727-3312-02
 ;;9002226.02101,"806,64727-3320-01 ",.01)
 ;;64727-3320-01
 ;;9002226.02101,"806,64727-3320-01 ",.02)
 ;;64727-3320-01
 ;;9002226.02101,"806,64727-3320-02 ",.01)
 ;;64727-3320-02
 ;;9002226.02101,"806,64727-3320-02 ",.02)
 ;;64727-3320-02
 ;;9002226.02101,"806,64727-3340-01 ",.01)
 ;;64727-3340-01
 ;;9002226.02101,"806,64727-3340-01 ",.02)
 ;;64727-3340-01
 ;;9002226.02101,"806,64727-3340-02 ",.01)
 ;;64727-3340-02
 ;;9002226.02101,"806,64727-3340-02 ",.02)
 ;;64727-3340-02
 ;;9002226.02101,"806,64727-4050-01 ",.01)
 ;;64727-4050-01
 ;;9002226.02101,"806,64727-4050-01 ",.02)
 ;;64727-4050-01
 ;;9002226.02101,"806,64727-4050-02 ",.01)
 ;;64727-4050-02
 ;;9002226.02101,"806,64727-4050-02 ",.02)
 ;;64727-4050-02
 ;;9002226.02101,"806,64727-4150-01 ",.01)
 ;;64727-4150-01
 ;;9002226.02101,"806,64727-4150-01 ",.02)
 ;;64727-4150-01
 ;;9002226.02101,"806,64727-4150-02 ",.01)
 ;;64727-4150-02
 ;;9002226.02101,"806,64727-4150-02 ",.02)
 ;;64727-4150-02
 ;;9002226.02101,"806,64727-4250-01 ",.01)
 ;;64727-4250-01
 ;;9002226.02101,"806,64727-4250-01 ",.02)
 ;;64727-4250-01
 ;;9002226.02101,"806,64727-4250-02 ",.01)
 ;;64727-4250-02
 ;;9002226.02101,"806,64727-4250-02 ",.02)
 ;;64727-4250-02
 ;;9002226.02101,"806,64727-4350-01 ",.01)
 ;;64727-4350-01
 ;;9002226.02101,"806,64727-4350-01 ",.02)
 ;;64727-4350-01
 ;;9002226.02101,"806,64727-4350-02 ",.01)
 ;;64727-4350-02
 ;;9002226.02101,"806,64727-4350-02 ",.02)
 ;;64727-4350-02
 ;;9002226.02101,"806,64727-4450-01 ",.01)
 ;;64727-4450-01
 ;;9002226.02101,"806,64727-4450-01 ",.02)
 ;;64727-4450-01
 ;;9002226.02101,"806,64727-4450-02 ",.01)
 ;;64727-4450-02
 ;;9002226.02101,"806,64727-4450-02 ",.02)
 ;;64727-4450-02
 ;;9002226.02101,"806,64727-4550-01 ",.01)
 ;;64727-4550-01
 ;;9002226.02101,"806,64727-4550-01 ",.02)
 ;;64727-4550-01
 ;;9002226.02101,"806,64727-4550-02 ",.01)
 ;;64727-4550-02
 ;;9002226.02101,"806,64727-4550-02 ",.02)
 ;;64727-4550-02
 ;;9002226.02101,"806,64727-5450-01 ",.01)
 ;;64727-5450-01
 ;;9002226.02101,"806,64727-5450-01 ",.02)
 ;;64727-5450-01
 ;;9002226.02101,"806,64727-5450-02 ",.01)
 ;;64727-5450-02
 ;;9002226.02101,"806,64727-5450-02 ",.02)
 ;;64727-5450-02
 ;;9002226.02101,"806,64727-5550-01 ",.01)
 ;;64727-5550-01
 ;;9002226.02101,"806,64727-5550-01 ",.02)
 ;;64727-5550-01
 ;;9002226.02101,"806,64727-5550-02 ",.01)
 ;;64727-5550-02
 ;;9002226.02101,"806,64727-5550-02 ",.02)
 ;;64727-5550-02
 ;;9002226.02101,"806,64727-5650-01 ",.01)
 ;;64727-5650-01
 ;;9002226.02101,"806,64727-5650-01 ",.02)
 ;;64727-5650-01
 ;;9002226.02101,"806,64727-5650-02 ",.01)
 ;;64727-5650-02
 ;;9002226.02101,"806,64727-5650-02 ",.02)
 ;;64727-5650-02
 ;;9002226.02101,"806,64727-5750-01 ",.01)
 ;;64727-5750-01
 ;;9002226.02101,"806,64727-5750-01 ",.02)
 ;;64727-5750-01
 ;;9002226.02101,"806,64727-5750-02 ",.01)
 ;;64727-5750-02
 ;;9002226.02101,"806,64727-5750-02 ",.02)
 ;;64727-5750-02
 ;;9002226.02101,"806,64727-5850-01 ",.01)
 ;;64727-5850-01
 ;;9002226.02101,"806,64727-5850-01 ",.02)
 ;;64727-5850-01
 ;;9002226.02101,"806,64727-5850-02 ",.01)
 ;;64727-5850-02
 ;;9002226.02101,"806,64727-5850-02 ",.02)
 ;;64727-5850-02
 ;;9002226.02101,"806,64727-5950-01 ",.01)
 ;;64727-5950-01
 ;;9002226.02101,"806,64727-5950-01 ",.02)
 ;;64727-5950-01
 ;;9002226.02101,"806,64727-5950-02 ",.01)
 ;;64727-5950-02
 ;;9002226.02101,"806,64727-5950-02 ",.02)
 ;;64727-5950-02
 ;;9002226.02101,"806,64727-6050-01 ",.01)
 ;;64727-6050-01
 ;;9002226.02101,"806,64727-6050-01 ",.02)
 ;;64727-6050-01
 ;;9002226.02101,"806,64727-6050-02 ",.01)
 ;;64727-6050-02
 ;;9002226.02101,"806,64727-6050-02 ",.02)
 ;;64727-6050-02
 ;;9002226.02101,"806,64727-6150-01 ",.01)
 ;;64727-6150-01
 ;;9002226.02101,"806,64727-6150-01 ",.02)
 ;;64727-6150-01
 ;;9002226.02101,"806,64727-6150-02 ",.01)
 ;;64727-6150-02
 ;;9002226.02101,"806,64727-6150-02 ",.02)
 ;;64727-6150-02
 ;;9002226.02101,"806,64727-7065-01 ",.01)
 ;;64727-7065-01
 ;;9002226.02101,"806,64727-7065-01 ",.02)
 ;;64727-7065-01
 ;;9002226.02101,"806,64727-7065-02 ",.01)
 ;;64727-7065-02
 ;;9002226.02101,"806,64727-7065-02 ",.02)
 ;;64727-7065-02
 ;;9002226.02101,"806,64727-7070-01 ",.01)
 ;;64727-7070-01
 ;;9002226.02101,"806,64727-7070-01 ",.02)
 ;;64727-7070-01
 ;;9002226.02101,"806,64727-7070-02 ",.01)
 ;;64727-7070-02
 ;;9002226.02101,"806,64727-7070-02 ",.02)
 ;;64727-7070-02
 ;;9002226.02101,"806,64727-7072-01 ",.01)
 ;;64727-7072-01
 ;;9002226.02101,"806,64727-7072-01 ",.02)
 ;;64727-7072-01
 ;;9002226.02101,"806,64727-7072-02 ",.01)
 ;;64727-7072-02
 ;;9002226.02101,"806,64727-7072-02 ",.02)
 ;;64727-7072-02
 ;;9002226.02101,"806,64727-7073-01 ",.01)
 ;;64727-7073-01
 ;;9002226.02101,"806,64727-7073-01 ",.02)
 ;;64727-7073-01
 ;;9002226.02101,"806,64727-7073-02 ",.01)
 ;;64727-7073-02
 ;;9002226.02101,"806,64727-7073-02 ",.02)
 ;;64727-7073-02
 ;;9002226.02101,"806,64727-7074-01 ",.01)
 ;;64727-7074-01
 ;;9002226.02101,"806,64727-7074-01 ",.02)
 ;;64727-7074-01
 ;;9002226.02101,"806,64727-7074-02 ",.01)
 ;;64727-7074-02
 ;;9002226.02101,"806,64727-7074-02 ",.02)
 ;;64727-7074-02
 ;;9002226.02101,"806,64727-7075-01 ",.01)
 ;;64727-7075-01
 ;;9002226.02101,"806,64727-7075-01 ",.02)
 ;;64727-7075-01
 ;;9002226.02101,"806,64727-7075-02 ",.01)
 ;;64727-7075-02
 ;;9002226.02101,"806,64727-7075-02 ",.02)
 ;;64727-7075-02
 ;;9002226.02101,"806,64727-7078-01 ",.01)
 ;;64727-7078-01
 ;;9002226.02101,"806,64727-7078-01 ",.02)
 ;;64727-7078-01
 ;;9002226.02101,"806,64727-7078-02 ",.01)
 ;;64727-7078-02
 ;;9002226.02101,"806,64727-7078-02 ",.02)
 ;;64727-7078-02
 ;;9002226.02101,"806,64727-7080-01 ",.01)
 ;;64727-7080-01
 ;;9002226.02101,"806,64727-7080-01 ",.02)
 ;;64727-7080-01
 ;;9002226.02101,"806,64727-7080-02 ",.01)
 ;;64727-7080-02
 ;;9002226.02101,"806,64727-7080-02 ",.02)
 ;;64727-7080-02
 ;;9002226.02101,"806,64727-7085-01 ",.01)
 ;;64727-7085-01
 ;;9002226.02101,"806,64727-7085-01 ",.02)
 ;;64727-7085-01
 ;;9002226.02101,"806,64727-7085-02 ",.01)
 ;;64727-7085-02
 ;;9002226.02101,"806,64727-7085-02 ",.02)
 ;;64727-7085-02
 ;;9002226.02101,"806,64727-7090-01 ",.01)
 ;;64727-7090-01
 ;;9002226.02101,"806,64727-7090-01 ",.02)
 ;;64727-7090-01
 ;;9002226.02101,"806,64727-7090-02 ",.01)
 ;;64727-7090-02
 ;;9002226.02101,"806,64727-7090-02 ",.02)
 ;;64727-7090-02
 ;;9002226.02101,"806,64727-7095-01 ",.01)
 ;;64727-7095-01
 ;;9002226.02101,"806,64727-7095-01 ",.02)
 ;;64727-7095-01
 ;;9002226.02101,"806,64727-7095-02 ",.01)
 ;;64727-7095-02
 ;;9002226.02101,"806,64727-7095-02 ",.02)
 ;;64727-7095-02
 ;;9002226.02101,"806,64727-7100-01 ",.01)
 ;;64727-7100-01
 ;;9002226.02101,"806,64727-7100-01 ",.02)
 ;;64727-7100-01
 ;;9002226.02101,"806,64727-7100-02 ",.01)
 ;;64727-7100-02
 ;;9002226.02101,"806,64727-7100-02 ",.02)
 ;;64727-7100-02
 ;;9002226.02101,"806,64727-7150-01 ",.01)
 ;;64727-7150-01
 ;;9002226.02101,"806,64727-7150-01 ",.02)
 ;;64727-7150-01
 ;;9002226.02101,"806,64727-7150-02 ",.01)
 ;;64727-7150-02
 ;;9002226.02101,"806,64727-7150-02 ",.02)
 ;;64727-7150-02
 ;;9002226.02101,"806,65243-0176-09 ",.01)
 ;;65243-0176-09