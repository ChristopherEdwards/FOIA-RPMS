ATXXB111 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON APR 29, 2014;
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1804,0UP8XDZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0UPD7HZ ",.01)
 ;;0UPD7HZ 
 ;;9002226.02101,"1804,0UPD7HZ ",.02)
 ;;0UPD7HZ 
 ;;9002226.02101,"1804,0UPD7HZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0UPD8HZ ",.01)
 ;;0UPD8HZ 
 ;;9002226.02101,"1804,0UPD8HZ ",.02)
 ;;0UPD8HZ 
 ;;9002226.02101,"1804,0UPD8HZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0UPDX0Z ",.01)
 ;;0UPDX0Z 
 ;;9002226.02101,"1804,0UPDX0Z ",.02)
 ;;0UPDX0Z 
 ;;9002226.02101,"1804,0UPDX0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0UPDX3Z ",.01)
 ;;0UPDX3Z 
 ;;9002226.02101,"1804,0UPDX3Z ",.02)
 ;;0UPDX3Z 
 ;;9002226.02101,"1804,0UPDX3Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0UPDXDZ ",.01)
 ;;0UPDXDZ 
 ;;9002226.02101,"1804,0UPDXDZ ",.02)
 ;;0UPDXDZ 
 ;;9002226.02101,"1804,0UPDXDZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0UPDXHZ ",.01)
 ;;0UPDXHZ 
 ;;9002226.02101,"1804,0UPDXHZ ",.02)
 ;;0UPDXHZ 
 ;;9002226.02101,"1804,0UPDXHZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0UPHX0Z ",.01)
 ;;0UPHX0Z 
 ;;9002226.02101,"1804,0UPHX0Z ",.02)
 ;;0UPHX0Z 
 ;;9002226.02101,"1804,0UPHX0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0UPHX1Z ",.01)
 ;;0UPHX1Z 
 ;;9002226.02101,"1804,0UPHX1Z ",.02)
 ;;0UPHX1Z 
 ;;9002226.02101,"1804,0UPHX1Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0UPHX3Z ",.01)
 ;;0UPHX3Z 
 ;;9002226.02101,"1804,0UPHX3Z ",.02)
 ;;0UPHX3Z 
 ;;9002226.02101,"1804,0UPHX3Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0UPHXDZ ",.01)
 ;;0UPHXDZ 
 ;;9002226.02101,"1804,0UPHXDZ ",.02)
 ;;0UPHXDZ 
 ;;9002226.02101,"1804,0UPHXDZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0UPMX0Z ",.01)
 ;;0UPMX0Z 
 ;;9002226.02101,"1804,0UPMX0Z ",.02)
 ;;0UPMX0Z 
 ;;9002226.02101,"1804,0UPMX0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0UW3X0Z ",.01)
 ;;0UW3X0Z 
 ;;9002226.02101,"1804,0UW3X0Z ",.02)
 ;;0UW3X0Z 
 ;;9002226.02101,"1804,0UW3X0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0UW3X3Z ",.01)
 ;;0UW3X3Z 
 ;;9002226.02101,"1804,0UW3X3Z ",.02)
 ;;0UW3X3Z 
 ;;9002226.02101,"1804,0UW3X3Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0UW8X0Z ",.01)
 ;;0UW8X0Z 
 ;;9002226.02101,"1804,0UW8X0Z ",.02)
 ;;0UW8X0Z 
 ;;9002226.02101,"1804,0UW8X0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0UW8X3Z ",.01)
 ;;0UW8X3Z 
 ;;9002226.02101,"1804,0UW8X3Z ",.02)
 ;;0UW8X3Z 
 ;;9002226.02101,"1804,0UW8X3Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0UW8X7Z ",.01)
 ;;0UW8X7Z 
 ;;9002226.02101,"1804,0UW8X7Z ",.02)
 ;;0UW8X7Z 
 ;;9002226.02101,"1804,0UW8X7Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0UW8XCZ ",.01)
 ;;0UW8XCZ 
 ;;9002226.02101,"1804,0UW8XCZ ",.02)
 ;;0UW8XCZ 
 ;;9002226.02101,"1804,0UW8XCZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0UW8XDZ ",.01)
 ;;0UW8XDZ 
 ;;9002226.02101,"1804,0UW8XDZ ",.02)
 ;;0UW8XDZ 
 ;;9002226.02101,"1804,0UW8XDZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0UW8XJZ ",.01)
 ;;0UW8XJZ 
 ;;9002226.02101,"1804,0UW8XJZ ",.02)
 ;;0UW8XJZ 
 ;;9002226.02101,"1804,0UW8XJZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0UW8XKZ ",.01)
 ;;0UW8XKZ 
 ;;9002226.02101,"1804,0UW8XKZ ",.02)
 ;;0UW8XKZ 
 ;;9002226.02101,"1804,0UW8XKZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0UWDX0Z ",.01)
 ;;0UWDX0Z 
 ;;9002226.02101,"1804,0UWDX0Z ",.02)
 ;;0UWDX0Z 
 ;;9002226.02101,"1804,0UWDX0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0UWDX3Z ",.01)
 ;;0UWDX3Z 
 ;;9002226.02101,"1804,0UWDX3Z ",.02)
 ;;0UWDX3Z 
 ;;9002226.02101,"1804,0UWDX3Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0UWDX7Z ",.01)
 ;;0UWDX7Z 
 ;;9002226.02101,"1804,0UWDX7Z ",.02)
 ;;0UWDX7Z 
 ;;9002226.02101,"1804,0UWDX7Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0UWDXCZ ",.01)
 ;;0UWDXCZ 
 ;;9002226.02101,"1804,0UWDXCZ ",.02)
 ;;0UWDXCZ 
 ;;9002226.02101,"1804,0UWDXCZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0UWDXDZ ",.01)
 ;;0UWDXDZ 
 ;;9002226.02101,"1804,0UWDXDZ ",.02)
 ;;0UWDXDZ 
 ;;9002226.02101,"1804,0UWDXDZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0UWDXHZ ",.01)
 ;;0UWDXHZ 
 ;;9002226.02101,"1804,0UWDXHZ ",.02)
 ;;0UWDXHZ 
 ;;9002226.02101,"1804,0UWDXHZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0UWDXJZ ",.01)
 ;;0UWDXJZ 
 ;;9002226.02101,"1804,0UWDXJZ ",.02)
 ;;0UWDXJZ 
 ;;9002226.02101,"1804,0UWDXJZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0UWDXKZ ",.01)
 ;;0UWDXKZ 
 ;;9002226.02101,"1804,0UWDXKZ ",.02)
 ;;0UWDXKZ 
 ;;9002226.02101,"1804,0UWDXKZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0UWHX0Z ",.01)
 ;;0UWHX0Z 
 ;;9002226.02101,"1804,0UWHX0Z ",.02)
 ;;0UWHX0Z 
 ;;9002226.02101,"1804,0UWHX0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0UWHX3Z ",.01)
 ;;0UWHX3Z 
 ;;9002226.02101,"1804,0UWHX3Z ",.02)
 ;;0UWHX3Z 
 ;;9002226.02101,"1804,0UWHX3Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0UWHX7Z ",.01)
 ;;0UWHX7Z 
 ;;9002226.02101,"1804,0UWHX7Z ",.02)
 ;;0UWHX7Z 
 ;;9002226.02101,"1804,0UWHX7Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0UWHXDZ ",.01)
 ;;0UWHXDZ 
 ;;9002226.02101,"1804,0UWHXDZ ",.02)
 ;;0UWHXDZ 
 ;;9002226.02101,"1804,0UWHXDZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0UWHXJZ ",.01)
 ;;0UWHXJZ 
 ;;9002226.02101,"1804,0UWHXJZ ",.02)
 ;;0UWHXJZ 
 ;;9002226.02101,"1804,0UWHXJZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0UWHXKZ ",.01)
 ;;0UWHXKZ 
 ;;9002226.02101,"1804,0UWHXKZ ",.02)
 ;;0UWHXKZ 
 ;;9002226.02101,"1804,0UWHXKZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0UWMX0Z ",.01)
 ;;0UWMX0Z 
 ;;9002226.02101,"1804,0UWMX0Z ",.02)
 ;;0UWMX0Z 
 ;;9002226.02101,"1804,0UWMX0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0UWMX7Z ",.01)
 ;;0UWMX7Z 
 ;;9002226.02101,"1804,0UWMX7Z ",.02)
 ;;0UWMX7Z 
 ;;9002226.02101,"1804,0UWMX7Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0UWMXJZ ",.01)
 ;;0UWMXJZ 
 ;;9002226.02101,"1804,0UWMXJZ ",.02)
 ;;0UWMXJZ 
 ;;9002226.02101,"1804,0UWMXJZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0UWMXKZ ",.01)
 ;;0UWMXKZ 
 ;;9002226.02101,"1804,0UWMXKZ ",.02)
 ;;0UWMXKZ 
 ;;9002226.02101,"1804,0UWMXKZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0V24X0Z ",.01)
 ;;0V24X0Z 
 ;;9002226.02101,"1804,0V24X0Z ",.02)
 ;;0V24X0Z 
 ;;9002226.02101,"1804,0V24X0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0V24XYZ ",.01)
 ;;0V24XYZ 
 ;;9002226.02101,"1804,0V24XYZ ",.02)
 ;;0V24XYZ 
 ;;9002226.02101,"1804,0V24XYZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0V28X0Z ",.01)
 ;;0V28X0Z 
 ;;9002226.02101,"1804,0V28X0Z ",.02)
 ;;0V28X0Z 
 ;;9002226.02101,"1804,0V28X0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0V28XYZ ",.01)
 ;;0V28XYZ 
 ;;9002226.02101,"1804,0V28XYZ ",.02)
 ;;0V28XYZ 
 ;;9002226.02101,"1804,0V28XYZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0V2DX0Z ",.01)
 ;;0V2DX0Z 
 ;;9002226.02101,"1804,0V2DX0Z ",.02)
 ;;0V2DX0Z 
 ;;9002226.02101,"1804,0V2DX0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0V2DXYZ ",.01)
 ;;0V2DXYZ 
 ;;9002226.02101,"1804,0V2DXYZ ",.02)
 ;;0V2DXYZ 
 ;;9002226.02101,"1804,0V2DXYZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0V2MX0Z ",.01)
 ;;0V2MX0Z 
 ;;9002226.02101,"1804,0V2MX0Z ",.02)
 ;;0V2MX0Z 
 ;;9002226.02101,"1804,0V2MX0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0V2MXYZ ",.01)
 ;;0V2MXYZ 
 ;;9002226.02101,"1804,0V2MXYZ ",.02)
 ;;0V2MXYZ 
 ;;9002226.02101,"1804,0V2MXYZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0V2RX0Z ",.01)
 ;;0V2RX0Z 
 ;;9002226.02101,"1804,0V2RX0Z ",.02)
 ;;0V2RX0Z 
 ;;9002226.02101,"1804,0V2RX0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0V2RXYZ ",.01)
 ;;0V2RXYZ 
 ;;9002226.02101,"1804,0V2RXYZ ",.02)
 ;;0V2RXYZ 
 ;;9002226.02101,"1804,0V2RXYZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0V2SX0Z ",.01)
 ;;0V2SX0Z 
 ;;9002226.02101,"1804,0V2SX0Z ",.02)
 ;;0V2SX0Z 
 ;;9002226.02101,"1804,0V2SX0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0V2SXYZ ",.01)
 ;;0V2SXYZ 
 ;;9002226.02101,"1804,0V2SXYZ ",.02)
 ;;0V2SXYZ 
 ;;9002226.02101,"1804,0V2SXYZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0VC5XZZ ",.01)
 ;;0VC5XZZ 
 ;;9002226.02101,"1804,0VC5XZZ ",.02)
 ;;0VC5XZZ 
 ;;9002226.02101,"1804,0VC5XZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0VCSXZZ ",.01)
 ;;0VCSXZZ 
 ;;9002226.02101,"1804,0VCSXZZ ",.02)
 ;;0VCSXZZ 
 ;;9002226.02101,"1804,0VCSXZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0VH001Z ",.01)
 ;;0VH001Z 
 ;;9002226.02101,"1804,0VH001Z ",.02)
 ;;0VH001Z 
 ;;9002226.02101,"1804,0VH001Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0VH031Z ",.01)
 ;;0VH031Z 
 ;;9002226.02101,"1804,0VH031Z ",.02)
 ;;0VH031Z 
 ;;9002226.02101,"1804,0VH031Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0VH041Z ",.01)
 ;;0VH041Z 
 ;;9002226.02101,"1804,0VH041Z ",.02)
 ;;0VH041Z 
 ;;9002226.02101,"1804,0VH041Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0VH071Z ",.01)
 ;;0VH071Z 
 ;;9002226.02101,"1804,0VH071Z ",.02)
 ;;0VH071Z 
 ;;9002226.02101,"1804,0VH071Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0VH081Z ",.01)
 ;;0VH081Z 
 ;;9002226.02101,"1804,0VH081Z ",.02)
 ;;0VH081Z 
 ;;9002226.02101,"1804,0VH081Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0VH403Z ",.01)
 ;;0VH403Z 
 ;;9002226.02101,"1804,0VH403Z ",.02)
 ;;0VH403Z 
 ;;9002226.02101,"1804,0VH403Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0VH433Z ",.01)
 ;;0VH433Z 
 ;;9002226.02101,"1804,0VH433Z ",.02)
 ;;0VH433Z 
 ;;9002226.02101,"1804,0VH433Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0VH443Z ",.01)
 ;;0VH443Z 
 ;;9002226.02101,"1804,0VH443Z ",.02)
 ;;0VH443Z 
 ;;9002226.02101,"1804,0VH443Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0VH473Z ",.01)
 ;;0VH473Z 
 ;;9002226.02101,"1804,0VH473Z ",.02)
 ;;0VH473Z 
 ;;9002226.02101,"1804,0VH473Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0VH483Z ",.01)
 ;;0VH483Z 
 ;;9002226.02101,"1804,0VH483Z ",.02)
 ;;0VH483Z 
 ;;9002226.02101,"1804,0VH483Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0VH803Z ",.01)
 ;;0VH803Z 
 ;;9002226.02101,"1804,0VH803Z ",.02)
 ;;0VH803Z 
 ;;9002226.02101,"1804,0VH803Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0VH833Z ",.01)
 ;;0VH833Z 
 ;;9002226.02101,"1804,0VH833Z ",.02)
 ;;0VH833Z 
 ;;9002226.02101,"1804,0VH833Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0VH843Z ",.01)
 ;;0VH843Z 
 ;;9002226.02101,"1804,0VH843Z ",.02)
 ;;0VH843Z 
 ;;9002226.02101,"1804,0VH843Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0VH873Z ",.01)
 ;;0VH873Z 
 ;;9002226.02101,"1804,0VH873Z ",.02)
 ;;0VH873Z 
 ;;9002226.02101,"1804,0VH873Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0VH883Z ",.01)
 ;;0VH883Z 
 ;;9002226.02101,"1804,0VH883Z ",.02)
 ;;0VH883Z 
 ;;9002226.02101,"1804,0VH883Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0VHD03Z ",.01)
 ;;0VHD03Z 
 ;;9002226.02101,"1804,0VHD03Z ",.02)
 ;;0VHD03Z 
 ;;9002226.02101,"1804,0VHD03Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0VHD33Z ",.01)
 ;;0VHD33Z 
 ;;9002226.02101,"1804,0VHD33Z ",.02)
 ;;0VHD33Z 
 ;;9002226.02101,"1804,0VHD33Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0VHD43Z ",.01)
 ;;0VHD43Z 
 ;;9002226.02101,"1804,0VHD43Z ",.02)
 ;;0VHD43Z 
 ;;9002226.02101,"1804,0VHD43Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0VHD73Z ",.01)
 ;;0VHD73Z 
 ;;9002226.02101,"1804,0VHD73Z ",.02)
 ;;0VHD73Z 
 ;;9002226.02101,"1804,0VHD73Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0VHD83Z ",.01)
 ;;0VHD83Z 
 ;;9002226.02101,"1804,0VHD83Z ",.02)
 ;;0VHD83Z 
 ;;9002226.02101,"1804,0VHD83Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0VHM03Z ",.01)
 ;;0VHM03Z 
 ;;9002226.02101,"1804,0VHM03Z ",.02)
 ;;0VHM03Z 
 ;;9002226.02101,"1804,0VHM03Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0VHM33Z ",.01)
 ;;0VHM33Z 
 ;;9002226.02101,"1804,0VHM33Z ",.02)
 ;;0VHM33Z 
 ;;9002226.02101,"1804,0VHM33Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0VHM43Z ",.01)
 ;;0VHM43Z 
 ;;9002226.02101,"1804,0VHM43Z ",.02)
 ;;0VHM43Z 
 ;;9002226.02101,"1804,0VHM43Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0VHM73Z ",.01)
 ;;0VHM73Z 
 ;;9002226.02101,"1804,0VHM73Z ",.02)
 ;;0VHM73Z 
 ;;9002226.02101,"1804,0VHM73Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0VHM83Z ",.01)
 ;;0VHM83Z 
 ;;9002226.02101,"1804,0VHM83Z ",.02)
 ;;0VHM83Z 
 ;;9002226.02101,"1804,0VHM83Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0VHR03Z ",.01)
 ;;0VHR03Z 
 ;;9002226.02101,"1804,0VHR03Z ",.02)
 ;;0VHR03Z 
 ;;9002226.02101,"1804,0VHR03Z ",.03)
 ;;31