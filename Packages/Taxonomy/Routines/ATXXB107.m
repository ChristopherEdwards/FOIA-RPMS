ATXXB107 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON APR 29, 2014;
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1804,0SW3XKZ ",.02)
 ;;0SW3XKZ 
 ;;9002226.02101,"1804,0SW3XKZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0SW4X0Z ",.01)
 ;;0SW4X0Z 
 ;;9002226.02101,"1804,0SW4X0Z ",.02)
 ;;0SW4X0Z 
 ;;9002226.02101,"1804,0SW4X0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SW4X3Z ",.01)
 ;;0SW4X3Z 
 ;;9002226.02101,"1804,0SW4X3Z ",.02)
 ;;0SW4X3Z 
 ;;9002226.02101,"1804,0SW4X3Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SW4X7Z ",.01)
 ;;0SW4X7Z 
 ;;9002226.02101,"1804,0SW4X7Z ",.02)
 ;;0SW4X7Z 
 ;;9002226.02101,"1804,0SW4X7Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SW4XJZ ",.01)
 ;;0SW4XJZ 
 ;;9002226.02101,"1804,0SW4XJZ ",.02)
 ;;0SW4XJZ 
 ;;9002226.02101,"1804,0SW4XJZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0SW4XKZ ",.01)
 ;;0SW4XKZ 
 ;;9002226.02101,"1804,0SW4XKZ ",.02)
 ;;0SW4XKZ 
 ;;9002226.02101,"1804,0SW4XKZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0SW5X0Z ",.01)
 ;;0SW5X0Z 
 ;;9002226.02101,"1804,0SW5X0Z ",.02)
 ;;0SW5X0Z 
 ;;9002226.02101,"1804,0SW5X0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SW5X3Z ",.01)
 ;;0SW5X3Z 
 ;;9002226.02101,"1804,0SW5X3Z ",.02)
 ;;0SW5X3Z 
 ;;9002226.02101,"1804,0SW5X3Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SW5X4Z ",.01)
 ;;0SW5X4Z 
 ;;9002226.02101,"1804,0SW5X4Z ",.02)
 ;;0SW5X4Z 
 ;;9002226.02101,"1804,0SW5X4Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SW5X7Z ",.01)
 ;;0SW5X7Z 
 ;;9002226.02101,"1804,0SW5X7Z ",.02)
 ;;0SW5X7Z 
 ;;9002226.02101,"1804,0SW5X7Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SW5X8Z ",.01)
 ;;0SW5X8Z 
 ;;9002226.02101,"1804,0SW5X8Z ",.02)
 ;;0SW5X8Z 
 ;;9002226.02101,"1804,0SW5X8Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SW5XJZ ",.01)
 ;;0SW5XJZ 
 ;;9002226.02101,"1804,0SW5XJZ ",.02)
 ;;0SW5XJZ 
 ;;9002226.02101,"1804,0SW5XJZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0SW5XKZ ",.01)
 ;;0SW5XKZ 
 ;;9002226.02101,"1804,0SW5XKZ ",.02)
 ;;0SW5XKZ 
 ;;9002226.02101,"1804,0SW5XKZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0SW6X0Z ",.01)
 ;;0SW6X0Z 
 ;;9002226.02101,"1804,0SW6X0Z ",.02)
 ;;0SW6X0Z 
 ;;9002226.02101,"1804,0SW6X0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SW6X3Z ",.01)
 ;;0SW6X3Z 
 ;;9002226.02101,"1804,0SW6X3Z ",.02)
 ;;0SW6X3Z 
 ;;9002226.02101,"1804,0SW6X3Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SW6X4Z ",.01)
 ;;0SW6X4Z 
 ;;9002226.02101,"1804,0SW6X4Z ",.02)
 ;;0SW6X4Z 
 ;;9002226.02101,"1804,0SW6X4Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SW6X7Z ",.01)
 ;;0SW6X7Z 
 ;;9002226.02101,"1804,0SW6X7Z ",.02)
 ;;0SW6X7Z 
 ;;9002226.02101,"1804,0SW6X7Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SW6X8Z ",.01)
 ;;0SW6X8Z 
 ;;9002226.02101,"1804,0SW6X8Z ",.02)
 ;;0SW6X8Z 
 ;;9002226.02101,"1804,0SW6X8Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SW6XJZ ",.01)
 ;;0SW6XJZ 
 ;;9002226.02101,"1804,0SW6XJZ ",.02)
 ;;0SW6XJZ 
 ;;9002226.02101,"1804,0SW6XJZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0SW6XKZ ",.01)
 ;;0SW6XKZ 
 ;;9002226.02101,"1804,0SW6XKZ ",.02)
 ;;0SW6XKZ 
 ;;9002226.02101,"1804,0SW6XKZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0SW7X0Z ",.01)
 ;;0SW7X0Z 
 ;;9002226.02101,"1804,0SW7X0Z ",.02)
 ;;0SW7X0Z 
 ;;9002226.02101,"1804,0SW7X0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SW7X3Z ",.01)
 ;;0SW7X3Z 
 ;;9002226.02101,"1804,0SW7X3Z ",.02)
 ;;0SW7X3Z 
 ;;9002226.02101,"1804,0SW7X3Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SW7X4Z ",.01)
 ;;0SW7X4Z 
 ;;9002226.02101,"1804,0SW7X4Z ",.02)
 ;;0SW7X4Z 
 ;;9002226.02101,"1804,0SW7X4Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SW7X7Z ",.01)
 ;;0SW7X7Z 
 ;;9002226.02101,"1804,0SW7X7Z ",.02)
 ;;0SW7X7Z 
 ;;9002226.02101,"1804,0SW7X7Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SW7X8Z ",.01)
 ;;0SW7X8Z 
 ;;9002226.02101,"1804,0SW7X8Z ",.02)
 ;;0SW7X8Z 
 ;;9002226.02101,"1804,0SW7X8Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SW7XJZ ",.01)
 ;;0SW7XJZ 
 ;;9002226.02101,"1804,0SW7XJZ ",.02)
 ;;0SW7XJZ 
 ;;9002226.02101,"1804,0SW7XJZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0SW7XKZ ",.01)
 ;;0SW7XKZ 
 ;;9002226.02101,"1804,0SW7XKZ ",.02)
 ;;0SW7XKZ 
 ;;9002226.02101,"1804,0SW7XKZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0SW8X0Z ",.01)
 ;;0SW8X0Z 
 ;;9002226.02101,"1804,0SW8X0Z ",.02)
 ;;0SW8X0Z 
 ;;9002226.02101,"1804,0SW8X0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SW8X3Z ",.01)
 ;;0SW8X3Z 
 ;;9002226.02101,"1804,0SW8X3Z ",.02)
 ;;0SW8X3Z 
 ;;9002226.02101,"1804,0SW8X3Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SW8X4Z ",.01)
 ;;0SW8X4Z 
 ;;9002226.02101,"1804,0SW8X4Z ",.02)
 ;;0SW8X4Z 
 ;;9002226.02101,"1804,0SW8X4Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SW8X7Z ",.01)
 ;;0SW8X7Z 
 ;;9002226.02101,"1804,0SW8X7Z ",.02)
 ;;0SW8X7Z 
 ;;9002226.02101,"1804,0SW8X7Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SW8X8Z ",.01)
 ;;0SW8X8Z 
 ;;9002226.02101,"1804,0SW8X8Z ",.02)
 ;;0SW8X8Z 
 ;;9002226.02101,"1804,0SW8X8Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SW8XJZ ",.01)
 ;;0SW8XJZ 
 ;;9002226.02101,"1804,0SW8XJZ ",.02)
 ;;0SW8XJZ 
 ;;9002226.02101,"1804,0SW8XJZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0SW8XKZ ",.01)
 ;;0SW8XKZ 
 ;;9002226.02101,"1804,0SW8XKZ ",.02)
 ;;0SW8XKZ 
 ;;9002226.02101,"1804,0SW8XKZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0SW9X0Z ",.01)
 ;;0SW9X0Z 
 ;;9002226.02101,"1804,0SW9X0Z ",.02)
 ;;0SW9X0Z 
 ;;9002226.02101,"1804,0SW9X0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SW9X3Z ",.01)
 ;;0SW9X3Z 
 ;;9002226.02101,"1804,0SW9X3Z ",.02)
 ;;0SW9X3Z 
 ;;9002226.02101,"1804,0SW9X3Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SW9X4Z ",.01)
 ;;0SW9X4Z 
 ;;9002226.02101,"1804,0SW9X4Z ",.02)
 ;;0SW9X4Z 
 ;;9002226.02101,"1804,0SW9X4Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SW9X5Z ",.01)
 ;;0SW9X5Z 
 ;;9002226.02101,"1804,0SW9X5Z ",.02)
 ;;0SW9X5Z 
 ;;9002226.02101,"1804,0SW9X5Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SW9X7Z ",.01)
 ;;0SW9X7Z 
 ;;9002226.02101,"1804,0SW9X7Z ",.02)
 ;;0SW9X7Z 
 ;;9002226.02101,"1804,0SW9X7Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SW9X8Z ",.01)
 ;;0SW9X8Z 
 ;;9002226.02101,"1804,0SW9X8Z ",.02)
 ;;0SW9X8Z 
 ;;9002226.02101,"1804,0SW9X8Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SW9XJZ ",.01)
 ;;0SW9XJZ 
 ;;9002226.02101,"1804,0SW9XJZ ",.02)
 ;;0SW9XJZ 
 ;;9002226.02101,"1804,0SW9XJZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0SW9XKZ ",.01)
 ;;0SW9XKZ 
 ;;9002226.02101,"1804,0SW9XKZ ",.02)
 ;;0SW9XKZ 
 ;;9002226.02101,"1804,0SW9XKZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0SWBX0Z ",.01)
 ;;0SWBX0Z 
 ;;9002226.02101,"1804,0SWBX0Z ",.02)
 ;;0SWBX0Z 
 ;;9002226.02101,"1804,0SWBX0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SWBX3Z ",.01)
 ;;0SWBX3Z 
 ;;9002226.02101,"1804,0SWBX3Z ",.02)
 ;;0SWBX3Z 
 ;;9002226.02101,"1804,0SWBX3Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SWBX4Z ",.01)
 ;;0SWBX4Z 
 ;;9002226.02101,"1804,0SWBX4Z ",.02)
 ;;0SWBX4Z 
 ;;9002226.02101,"1804,0SWBX4Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SWBX5Z ",.01)
 ;;0SWBX5Z 
 ;;9002226.02101,"1804,0SWBX5Z ",.02)
 ;;0SWBX5Z 
 ;;9002226.02101,"1804,0SWBX5Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SWBX7Z ",.01)
 ;;0SWBX7Z 
 ;;9002226.02101,"1804,0SWBX7Z ",.02)
 ;;0SWBX7Z 
 ;;9002226.02101,"1804,0SWBX7Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SWBX8Z ",.01)
 ;;0SWBX8Z 
 ;;9002226.02101,"1804,0SWBX8Z ",.02)
 ;;0SWBX8Z 
 ;;9002226.02101,"1804,0SWBX8Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SWBXJZ ",.01)
 ;;0SWBXJZ 
 ;;9002226.02101,"1804,0SWBXJZ ",.02)
 ;;0SWBXJZ 
 ;;9002226.02101,"1804,0SWBXJZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0SWBXKZ ",.01)
 ;;0SWBXKZ 
 ;;9002226.02101,"1804,0SWBXKZ ",.02)
 ;;0SWBXKZ 
 ;;9002226.02101,"1804,0SWBXKZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0SWCX0Z ",.01)
 ;;0SWCX0Z 
 ;;9002226.02101,"1804,0SWCX0Z ",.02)
 ;;0SWCX0Z 
 ;;9002226.02101,"1804,0SWCX0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SWCX3Z ",.01)
 ;;0SWCX3Z 
 ;;9002226.02101,"1804,0SWCX3Z ",.02)
 ;;0SWCX3Z 
 ;;9002226.02101,"1804,0SWCX3Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SWCX4Z ",.01)
 ;;0SWCX4Z 
 ;;9002226.02101,"1804,0SWCX4Z ",.02)
 ;;0SWCX4Z 
 ;;9002226.02101,"1804,0SWCX4Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SWCX5Z ",.01)
 ;;0SWCX5Z 
 ;;9002226.02101,"1804,0SWCX5Z ",.02)
 ;;0SWCX5Z 
 ;;9002226.02101,"1804,0SWCX5Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SWCX7Z ",.01)
 ;;0SWCX7Z 
 ;;9002226.02101,"1804,0SWCX7Z ",.02)
 ;;0SWCX7Z 
 ;;9002226.02101,"1804,0SWCX7Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SWCX8Z ",.01)
 ;;0SWCX8Z 
 ;;9002226.02101,"1804,0SWCX8Z ",.02)
 ;;0SWCX8Z 
 ;;9002226.02101,"1804,0SWCX8Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SWCXJZ ",.01)
 ;;0SWCXJZ 
 ;;9002226.02101,"1804,0SWCXJZ ",.02)
 ;;0SWCXJZ 
 ;;9002226.02101,"1804,0SWCXJZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0SWCXKZ ",.01)
 ;;0SWCXKZ 
 ;;9002226.02101,"1804,0SWCXKZ ",.02)
 ;;0SWCXKZ 
 ;;9002226.02101,"1804,0SWCXKZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0SWDX0Z ",.01)
 ;;0SWDX0Z 
 ;;9002226.02101,"1804,0SWDX0Z ",.02)
 ;;0SWDX0Z 
 ;;9002226.02101,"1804,0SWDX0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SWDX3Z ",.01)
 ;;0SWDX3Z 
 ;;9002226.02101,"1804,0SWDX3Z ",.02)
 ;;0SWDX3Z 
 ;;9002226.02101,"1804,0SWDX3Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SWDX4Z ",.01)
 ;;0SWDX4Z 
 ;;9002226.02101,"1804,0SWDX4Z ",.02)
 ;;0SWDX4Z 
 ;;9002226.02101,"1804,0SWDX4Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SWDX5Z ",.01)
 ;;0SWDX5Z 
 ;;9002226.02101,"1804,0SWDX5Z ",.02)
 ;;0SWDX5Z 
 ;;9002226.02101,"1804,0SWDX5Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SWDX7Z ",.01)
 ;;0SWDX7Z 
 ;;9002226.02101,"1804,0SWDX7Z ",.02)
 ;;0SWDX7Z 
 ;;9002226.02101,"1804,0SWDX7Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SWDX8Z ",.01)
 ;;0SWDX8Z 
 ;;9002226.02101,"1804,0SWDX8Z ",.02)
 ;;0SWDX8Z 
 ;;9002226.02101,"1804,0SWDX8Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SWDXJZ ",.01)
 ;;0SWDXJZ 
 ;;9002226.02101,"1804,0SWDXJZ ",.02)
 ;;0SWDXJZ 
 ;;9002226.02101,"1804,0SWDXJZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0SWDXKZ ",.01)
 ;;0SWDXKZ 
 ;;9002226.02101,"1804,0SWDXKZ ",.02)
 ;;0SWDXKZ 
 ;;9002226.02101,"1804,0SWDXKZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0SWFX0Z ",.01)
 ;;0SWFX0Z 
 ;;9002226.02101,"1804,0SWFX0Z ",.02)
 ;;0SWFX0Z 
 ;;9002226.02101,"1804,0SWFX0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SWFX3Z ",.01)
 ;;0SWFX3Z 
 ;;9002226.02101,"1804,0SWFX3Z ",.02)
 ;;0SWFX3Z 
 ;;9002226.02101,"1804,0SWFX3Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SWFX4Z ",.01)
 ;;0SWFX4Z 
 ;;9002226.02101,"1804,0SWFX4Z ",.02)
 ;;0SWFX4Z 
 ;;9002226.02101,"1804,0SWFX4Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SWFX5Z ",.01)
 ;;0SWFX5Z 
 ;;9002226.02101,"1804,0SWFX5Z ",.02)
 ;;0SWFX5Z 
 ;;9002226.02101,"1804,0SWFX5Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SWFX7Z ",.01)
 ;;0SWFX7Z 
 ;;9002226.02101,"1804,0SWFX7Z ",.02)
 ;;0SWFX7Z 
 ;;9002226.02101,"1804,0SWFX7Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SWFX8Z ",.01)
 ;;0SWFX8Z 
 ;;9002226.02101,"1804,0SWFX8Z ",.02)
 ;;0SWFX8Z 
 ;;9002226.02101,"1804,0SWFX8Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SWFXJZ ",.01)
 ;;0SWFXJZ 
 ;;9002226.02101,"1804,0SWFXJZ ",.02)
 ;;0SWFXJZ 
 ;;9002226.02101,"1804,0SWFXJZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0SWFXKZ ",.01)
 ;;0SWFXKZ 
 ;;9002226.02101,"1804,0SWFXKZ ",.02)
 ;;0SWFXKZ 
 ;;9002226.02101,"1804,0SWFXKZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0SWGX0Z ",.01)
 ;;0SWGX0Z 
 ;;9002226.02101,"1804,0SWGX0Z ",.02)
 ;;0SWGX0Z 
 ;;9002226.02101,"1804,0SWGX0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SWGX3Z ",.01)
 ;;0SWGX3Z 
 ;;9002226.02101,"1804,0SWGX3Z ",.02)
 ;;0SWGX3Z 
 ;;9002226.02101,"1804,0SWGX3Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SWGX4Z ",.01)
 ;;0SWGX4Z 
 ;;9002226.02101,"1804,0SWGX4Z ",.02)
 ;;0SWGX4Z 
 ;;9002226.02101,"1804,0SWGX4Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SWGX5Z ",.01)
 ;;0SWGX5Z 
 ;;9002226.02101,"1804,0SWGX5Z ",.02)
 ;;0SWGX5Z 
 ;;9002226.02101,"1804,0SWGX5Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0SWGX7Z ",.01)
 ;;0SWGX7Z 
 ;;9002226.02101,"1804,0SWGX7Z ",.02)
 ;;0SWGX7Z 