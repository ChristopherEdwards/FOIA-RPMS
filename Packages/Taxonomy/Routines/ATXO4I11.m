ATXO4I11 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON NOV 22, 2013;
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"752,047W0ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,047W34Z ",.01)
 ;;047W34Z 
 ;;9002226.02101,"752,047W34Z ",.02)
 ;;047W34Z 
 ;;9002226.02101,"752,047W34Z ",.03)
 ;;31
 ;;9002226.02101,"752,047W3DZ ",.01)
 ;;047W3DZ 
 ;;9002226.02101,"752,047W3DZ ",.02)
 ;;047W3DZ 
 ;;9002226.02101,"752,047W3DZ ",.03)
 ;;31
 ;;9002226.02101,"752,047W3ZZ ",.01)
 ;;047W3ZZ 
 ;;9002226.02101,"752,047W3ZZ ",.02)
 ;;047W3ZZ 
 ;;9002226.02101,"752,047W3ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,047W44Z ",.01)
 ;;047W44Z 
 ;;9002226.02101,"752,047W44Z ",.02)
 ;;047W44Z 
 ;;9002226.02101,"752,047W44Z ",.03)
 ;;31
 ;;9002226.02101,"752,047W4DZ ",.01)
 ;;047W4DZ 
 ;;9002226.02101,"752,047W4DZ ",.02)
 ;;047W4DZ 
 ;;9002226.02101,"752,047W4DZ ",.03)
 ;;31
 ;;9002226.02101,"752,047W4ZZ ",.01)
 ;;047W4ZZ 
 ;;9002226.02101,"752,047W4ZZ ",.02)
 ;;047W4ZZ 
 ;;9002226.02101,"752,047W4ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,047Y04Z ",.01)
 ;;047Y04Z 
 ;;9002226.02101,"752,047Y04Z ",.02)
 ;;047Y04Z 
 ;;9002226.02101,"752,047Y04Z ",.03)
 ;;31
 ;;9002226.02101,"752,047Y0DZ ",.01)
 ;;047Y0DZ 
 ;;9002226.02101,"752,047Y0DZ ",.02)
 ;;047Y0DZ 
 ;;9002226.02101,"752,047Y0DZ ",.03)
 ;;31
 ;;9002226.02101,"752,047Y0ZZ ",.01)
 ;;047Y0ZZ 
 ;;9002226.02101,"752,047Y0ZZ ",.02)
 ;;047Y0ZZ 
 ;;9002226.02101,"752,047Y0ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,047Y34Z ",.01)
 ;;047Y34Z 
 ;;9002226.02101,"752,047Y34Z ",.02)
 ;;047Y34Z 
 ;;9002226.02101,"752,047Y34Z ",.03)
 ;;31
 ;;9002226.02101,"752,047Y3DZ ",.01)
 ;;047Y3DZ 
 ;;9002226.02101,"752,047Y3DZ ",.02)
 ;;047Y3DZ 
 ;;9002226.02101,"752,047Y3DZ ",.03)
 ;;31
 ;;9002226.02101,"752,047Y3ZZ ",.01)
 ;;047Y3ZZ 
 ;;9002226.02101,"752,047Y3ZZ ",.02)
 ;;047Y3ZZ 
 ;;9002226.02101,"752,047Y3ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,047Y44Z ",.01)
 ;;047Y44Z 
 ;;9002226.02101,"752,047Y44Z ",.02)
 ;;047Y44Z 
 ;;9002226.02101,"752,047Y44Z ",.03)
 ;;31
 ;;9002226.02101,"752,047Y4DZ ",.01)
 ;;047Y4DZ 
 ;;9002226.02101,"752,047Y4DZ ",.02)
 ;;047Y4DZ 
 ;;9002226.02101,"752,047Y4DZ ",.03)
 ;;31
 ;;9002226.02101,"752,047Y4ZZ ",.01)
 ;;047Y4ZZ 
 ;;9002226.02101,"752,047Y4ZZ ",.02)
 ;;047Y4ZZ 
 ;;9002226.02101,"752,047Y4ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04C00ZZ ",.01)
 ;;04C00ZZ 
 ;;9002226.02101,"752,04C00ZZ ",.02)
 ;;04C00ZZ 
 ;;9002226.02101,"752,04C00ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04C03ZZ ",.01)
 ;;04C03ZZ 
 ;;9002226.02101,"752,04C03ZZ ",.02)
 ;;04C03ZZ 
 ;;9002226.02101,"752,04C03ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04C04ZZ ",.01)
 ;;04C04ZZ 
 ;;9002226.02101,"752,04C04ZZ ",.02)
 ;;04C04ZZ 
 ;;9002226.02101,"752,04C04ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04C10ZZ ",.01)
 ;;04C10ZZ 
 ;;9002226.02101,"752,04C10ZZ ",.02)
 ;;04C10ZZ 
 ;;9002226.02101,"752,04C10ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04C13ZZ ",.01)
 ;;04C13ZZ 
 ;;9002226.02101,"752,04C13ZZ ",.02)
 ;;04C13ZZ 
 ;;9002226.02101,"752,04C13ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04C14ZZ ",.01)
 ;;04C14ZZ 
 ;;9002226.02101,"752,04C14ZZ ",.02)
 ;;04C14ZZ 
 ;;9002226.02101,"752,04C14ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04C20ZZ ",.01)
 ;;04C20ZZ 
 ;;9002226.02101,"752,04C20ZZ ",.02)
 ;;04C20ZZ 
 ;;9002226.02101,"752,04C20ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04C23ZZ ",.01)
 ;;04C23ZZ 
 ;;9002226.02101,"752,04C23ZZ ",.02)
 ;;04C23ZZ 
 ;;9002226.02101,"752,04C23ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04C24ZZ ",.01)
 ;;04C24ZZ 
 ;;9002226.02101,"752,04C24ZZ ",.02)
 ;;04C24ZZ 
 ;;9002226.02101,"752,04C24ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04C30ZZ ",.01)
 ;;04C30ZZ 
 ;;9002226.02101,"752,04C30ZZ ",.02)
 ;;04C30ZZ 
 ;;9002226.02101,"752,04C30ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04C33ZZ ",.01)
 ;;04C33ZZ 
 ;;9002226.02101,"752,04C33ZZ ",.02)
 ;;04C33ZZ 
 ;;9002226.02101,"752,04C33ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04C34ZZ ",.01)
 ;;04C34ZZ 
 ;;9002226.02101,"752,04C34ZZ ",.02)
 ;;04C34ZZ 
 ;;9002226.02101,"752,04C34ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04C40ZZ ",.01)
 ;;04C40ZZ 
 ;;9002226.02101,"752,04C40ZZ ",.02)
 ;;04C40ZZ 
 ;;9002226.02101,"752,04C40ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04C43ZZ ",.01)
 ;;04C43ZZ 
 ;;9002226.02101,"752,04C43ZZ ",.02)
 ;;04C43ZZ 
 ;;9002226.02101,"752,04C43ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04C44ZZ ",.01)
 ;;04C44ZZ 
 ;;9002226.02101,"752,04C44ZZ ",.02)
 ;;04C44ZZ 
 ;;9002226.02101,"752,04C44ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04C50ZZ ",.01)
 ;;04C50ZZ 
 ;;9002226.02101,"752,04C50ZZ ",.02)
 ;;04C50ZZ 
 ;;9002226.02101,"752,04C50ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04C53ZZ ",.01)
 ;;04C53ZZ 
 ;;9002226.02101,"752,04C53ZZ ",.02)
 ;;04C53ZZ 
 ;;9002226.02101,"752,04C53ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04C54ZZ ",.01)
 ;;04C54ZZ 
 ;;9002226.02101,"752,04C54ZZ ",.02)
 ;;04C54ZZ 
 ;;9002226.02101,"752,04C54ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04C60ZZ ",.01)
 ;;04C60ZZ 
 ;;9002226.02101,"752,04C60ZZ ",.02)
 ;;04C60ZZ 
 ;;9002226.02101,"752,04C60ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04C63ZZ ",.01)
 ;;04C63ZZ 
 ;;9002226.02101,"752,04C63ZZ ",.02)
 ;;04C63ZZ 
 ;;9002226.02101,"752,04C63ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04C64ZZ ",.01)
 ;;04C64ZZ 
 ;;9002226.02101,"752,04C64ZZ ",.02)
 ;;04C64ZZ 
 ;;9002226.02101,"752,04C64ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04C70ZZ ",.01)
 ;;04C70ZZ 
 ;;9002226.02101,"752,04C70ZZ ",.02)
 ;;04C70ZZ 
 ;;9002226.02101,"752,04C70ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04C73ZZ ",.01)
 ;;04C73ZZ 
 ;;9002226.02101,"752,04C73ZZ ",.02)
 ;;04C73ZZ 
 ;;9002226.02101,"752,04C73ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04C74ZZ ",.01)
 ;;04C74ZZ 
 ;;9002226.02101,"752,04C74ZZ ",.02)
 ;;04C74ZZ 
 ;;9002226.02101,"752,04C74ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04C80ZZ ",.01)
 ;;04C80ZZ 
 ;;9002226.02101,"752,04C80ZZ ",.02)
 ;;04C80ZZ 
 ;;9002226.02101,"752,04C80ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04C83ZZ ",.01)
 ;;04C83ZZ 
 ;;9002226.02101,"752,04C83ZZ ",.02)
 ;;04C83ZZ 
 ;;9002226.02101,"752,04C83ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04C84ZZ ",.01)
 ;;04C84ZZ 
 ;;9002226.02101,"752,04C84ZZ ",.02)
 ;;04C84ZZ 
 ;;9002226.02101,"752,04C84ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04C90ZZ ",.01)
 ;;04C90ZZ 
 ;;9002226.02101,"752,04C90ZZ ",.02)
 ;;04C90ZZ 
 ;;9002226.02101,"752,04C90ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04C93ZZ ",.01)
 ;;04C93ZZ 
 ;;9002226.02101,"752,04C93ZZ ",.02)
 ;;04C93ZZ 
 ;;9002226.02101,"752,04C93ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04C94ZZ ",.01)
 ;;04C94ZZ 
 ;;9002226.02101,"752,04C94ZZ ",.02)
 ;;04C94ZZ 
 ;;9002226.02101,"752,04C94ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CA0ZZ ",.01)
 ;;04CA0ZZ 
 ;;9002226.02101,"752,04CA0ZZ ",.02)
 ;;04CA0ZZ 
 ;;9002226.02101,"752,04CA0ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CA3ZZ ",.01)
 ;;04CA3ZZ 
 ;;9002226.02101,"752,04CA3ZZ ",.02)
 ;;04CA3ZZ 
 ;;9002226.02101,"752,04CA3ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CA4ZZ ",.01)
 ;;04CA4ZZ 
 ;;9002226.02101,"752,04CA4ZZ ",.02)
 ;;04CA4ZZ 
 ;;9002226.02101,"752,04CA4ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CB0ZZ ",.01)
 ;;04CB0ZZ 
 ;;9002226.02101,"752,04CB0ZZ ",.02)
 ;;04CB0ZZ 
 ;;9002226.02101,"752,04CB0ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CB3ZZ ",.01)
 ;;04CB3ZZ 
 ;;9002226.02101,"752,04CB3ZZ ",.02)
 ;;04CB3ZZ 
 ;;9002226.02101,"752,04CB3ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CB4ZZ ",.01)
 ;;04CB4ZZ 
 ;;9002226.02101,"752,04CB4ZZ ",.02)
 ;;04CB4ZZ 
 ;;9002226.02101,"752,04CB4ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CC0ZZ ",.01)
 ;;04CC0ZZ 
 ;;9002226.02101,"752,04CC0ZZ ",.02)
 ;;04CC0ZZ 
 ;;9002226.02101,"752,04CC0ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CC3ZZ ",.01)
 ;;04CC3ZZ 
 ;;9002226.02101,"752,04CC3ZZ ",.02)
 ;;04CC3ZZ 
 ;;9002226.02101,"752,04CC3ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CC4ZZ ",.01)
 ;;04CC4ZZ 
 ;;9002226.02101,"752,04CC4ZZ ",.02)
 ;;04CC4ZZ 
 ;;9002226.02101,"752,04CC4ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CD0ZZ ",.01)
 ;;04CD0ZZ 
 ;;9002226.02101,"752,04CD0ZZ ",.02)
 ;;04CD0ZZ 
 ;;9002226.02101,"752,04CD0ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CD3ZZ ",.01)
 ;;04CD3ZZ 
 ;;9002226.02101,"752,04CD3ZZ ",.02)
 ;;04CD3ZZ 
 ;;9002226.02101,"752,04CD3ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CD4ZZ ",.01)
 ;;04CD4ZZ 
 ;;9002226.02101,"752,04CD4ZZ ",.02)
 ;;04CD4ZZ 
 ;;9002226.02101,"752,04CD4ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CE0ZZ ",.01)
 ;;04CE0ZZ 
 ;;9002226.02101,"752,04CE0ZZ ",.02)
 ;;04CE0ZZ 
 ;;9002226.02101,"752,04CE0ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CE3ZZ ",.01)
 ;;04CE3ZZ 
 ;;9002226.02101,"752,04CE3ZZ ",.02)
 ;;04CE3ZZ 
 ;;9002226.02101,"752,04CE3ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CE4ZZ ",.01)
 ;;04CE4ZZ 
 ;;9002226.02101,"752,04CE4ZZ ",.02)
 ;;04CE4ZZ 
 ;;9002226.02101,"752,04CE4ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CF0ZZ ",.01)
 ;;04CF0ZZ 
 ;;9002226.02101,"752,04CF0ZZ ",.02)
 ;;04CF0ZZ 
 ;;9002226.02101,"752,04CF0ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CF3ZZ ",.01)
 ;;04CF3ZZ 
 ;;9002226.02101,"752,04CF3ZZ ",.02)
 ;;04CF3ZZ 
 ;;9002226.02101,"752,04CF3ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CF4ZZ ",.01)
 ;;04CF4ZZ 
 ;;9002226.02101,"752,04CF4ZZ ",.02)
 ;;04CF4ZZ 
 ;;9002226.02101,"752,04CF4ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CH0ZZ ",.01)
 ;;04CH0ZZ 
 ;;9002226.02101,"752,04CH0ZZ ",.02)
 ;;04CH0ZZ 
 ;;9002226.02101,"752,04CH0ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CH3ZZ ",.01)
 ;;04CH3ZZ 
 ;;9002226.02101,"752,04CH3ZZ ",.02)
 ;;04CH3ZZ 
 ;;9002226.02101,"752,04CH3ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CH4ZZ ",.01)
 ;;04CH4ZZ 
 ;;9002226.02101,"752,04CH4ZZ ",.02)
 ;;04CH4ZZ 
 ;;9002226.02101,"752,04CH4ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CJ0ZZ ",.01)
 ;;04CJ0ZZ 
 ;;9002226.02101,"752,04CJ0ZZ ",.02)
 ;;04CJ0ZZ 
 ;;9002226.02101,"752,04CJ0ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CJ3ZZ ",.01)
 ;;04CJ3ZZ 
 ;;9002226.02101,"752,04CJ3ZZ ",.02)
 ;;04CJ3ZZ 
 ;;9002226.02101,"752,04CJ3ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CJ4ZZ ",.01)
 ;;04CJ4ZZ 
 ;;9002226.02101,"752,04CJ4ZZ ",.02)
 ;;04CJ4ZZ 
 ;;9002226.02101,"752,04CJ4ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CK0ZZ ",.01)
 ;;04CK0ZZ 
 ;;9002226.02101,"752,04CK0ZZ ",.02)
 ;;04CK0ZZ 
 ;;9002226.02101,"752,04CK0ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CK3ZZ ",.01)
 ;;04CK3ZZ 
 ;;9002226.02101,"752,04CK3ZZ ",.02)
 ;;04CK3ZZ 
 ;;9002226.02101,"752,04CK3ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CK4ZZ ",.01)
 ;;04CK4ZZ 
 ;;9002226.02101,"752,04CK4ZZ ",.02)
 ;;04CK4ZZ 
 ;;9002226.02101,"752,04CK4ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CL0ZZ ",.01)
 ;;04CL0ZZ 
 ;;9002226.02101,"752,04CL0ZZ ",.02)
 ;;04CL0ZZ 
 ;;9002226.02101,"752,04CL0ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CL3ZZ ",.01)
 ;;04CL3ZZ 
 ;;9002226.02101,"752,04CL3ZZ ",.02)
 ;;04CL3ZZ 
 ;;9002226.02101,"752,04CL3ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CL4ZZ ",.01)
 ;;04CL4ZZ 
 ;;9002226.02101,"752,04CL4ZZ ",.02)
 ;;04CL4ZZ 
 ;;9002226.02101,"752,04CL4ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CM0ZZ ",.01)
 ;;04CM0ZZ 
 ;;9002226.02101,"752,04CM0ZZ ",.02)
 ;;04CM0ZZ 
 ;;9002226.02101,"752,04CM0ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CM3ZZ ",.01)
 ;;04CM3ZZ 
 ;;9002226.02101,"752,04CM3ZZ ",.02)
 ;;04CM3ZZ 
 ;;9002226.02101,"752,04CM3ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CM4ZZ ",.01)
 ;;04CM4ZZ 
 ;;9002226.02101,"752,04CM4ZZ ",.02)
 ;;04CM4ZZ 
 ;;9002226.02101,"752,04CM4ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CN0ZZ ",.01)
 ;;04CN0ZZ 
 ;;9002226.02101,"752,04CN0ZZ ",.02)
 ;;04CN0ZZ 
 ;;9002226.02101,"752,04CN0ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CN3ZZ ",.01)
 ;;04CN3ZZ 
 ;;9002226.02101,"752,04CN3ZZ ",.02)
 ;;04CN3ZZ 
 ;;9002226.02101,"752,04CN3ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CN4ZZ ",.01)
 ;;04CN4ZZ 
 ;;9002226.02101,"752,04CN4ZZ ",.02)
 ;;04CN4ZZ 
 ;;9002226.02101,"752,04CN4ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CP0ZZ ",.01)
 ;;04CP0ZZ 
 ;;9002226.02101,"752,04CP0ZZ ",.02)
 ;;04CP0ZZ 
 ;;9002226.02101,"752,04CP0ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CP3ZZ ",.01)
 ;;04CP3ZZ 
 ;;9002226.02101,"752,04CP3ZZ ",.02)
 ;;04CP3ZZ 
 ;;9002226.02101,"752,04CP3ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CP4ZZ ",.01)
 ;;04CP4ZZ 
 ;;9002226.02101,"752,04CP4ZZ ",.02)
 ;;04CP4ZZ 
 ;;9002226.02101,"752,04CP4ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CQ0ZZ ",.01)
 ;;04CQ0ZZ 
 ;;9002226.02101,"752,04CQ0ZZ ",.02)
 ;;04CQ0ZZ 
 ;;9002226.02101,"752,04CQ0ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CQ3ZZ ",.01)
 ;;04CQ3ZZ 
 ;;9002226.02101,"752,04CQ3ZZ ",.02)
 ;;04CQ3ZZ 
 ;;9002226.02101,"752,04CQ3ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CQ4ZZ ",.01)
 ;;04CQ4ZZ 
 ;;9002226.02101,"752,04CQ4ZZ ",.02)
 ;;04CQ4ZZ 
 ;;9002226.02101,"752,04CQ4ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CR0ZZ ",.01)
 ;;04CR0ZZ 
 ;;9002226.02101,"752,04CR0ZZ ",.02)
 ;;04CR0ZZ 
 ;;9002226.02101,"752,04CR0ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CR3ZZ ",.01)
 ;;04CR3ZZ 
 ;;9002226.02101,"752,04CR3ZZ ",.02)
 ;;04CR3ZZ 
 ;;9002226.02101,"752,04CR3ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CR4ZZ ",.01)
 ;;04CR4ZZ 
 ;;9002226.02101,"752,04CR4ZZ ",.02)
 ;;04CR4ZZ 
 ;;9002226.02101,"752,04CR4ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CS0ZZ ",.01)
 ;;04CS0ZZ 
 ;;9002226.02101,"752,04CS0ZZ ",.02)
 ;;04CS0ZZ 
 ;;9002226.02101,"752,04CS0ZZ ",.03)
 ;;31
 ;;9002226.02101,"752,04CS3ZZ ",.01)
 ;;04CS3ZZ 
 ;;9002226.02101,"752,04CS3ZZ ",.02)
 ;;04CS3ZZ 
 ;;9002226.02101,"752,04CS3ZZ ",.03)
 ;;31