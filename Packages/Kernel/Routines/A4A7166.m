A4A7166 ; GLRISC/REL - Pre-Initialization ;5/31/89  07:29 [ 03/20/91  5:00 PM ]
 ;;1.01
 I $D(^VA(200)) G A1
 W *7,!!,"No data exists in File 200! You must run the Update pass"
 W !!,"before initializing the files. See the manual."
 W !!,"This initialization will abort ... " K DIFQ Q
A1 ; Delete Identifiers ...
 K ^DD(3,0,"ID"),^DD(16,0,"ID")
 ; Delete Original Cross-References
 K ^DD(3,.01,1),^DD(3,100,1),^DD(16,.01,1),^DD(16,30.003,1),^DD(16,30.006,1)
 ; Remove field 30.0031 from file 16
 S DIK="^DD(16,",DA=30.0031,DA(1)=16 D ^DIK
 ;IHS/MFD added contents of A4A7165 (A4A postinit) below
 W !!,"Re-indexing File 200 ..."
 S DIK="^VA(200," D IXALL^DIK Q
 Q
