ABMPFUNC ;IHS/ITSC/ENM,SDR - PHARM RETRIEVAL FUNCTIONS 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ; New Routine - 3/10/04
 ;
 ; Return NDC value
 ;input: RXIEN - Prescription IEN
 ;       RFIEN - Refill IEN
 ; Output: NDC value
NDCVAL(RX,RF)      ; EP - API Return NDC Value
 ; NDC value for prescription is returned if Refill IEN is not supplied
 N IENS,FILE,FLD
 S RF=$G(RF,0)
 Q:'$G(RX) ""
 S IENS=$S(RF:RF_","_RX_",",1:RX_",")
 S FILE=$S(RF:52.1,1:52)
 S FLD=$S(RF:11,1:27)
 Q $$GET1^DIQ(FILE,IENS,FLD)
 Q
