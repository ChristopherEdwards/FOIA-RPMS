BGP53J13 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON FEB 23, 2015;
 ;;15.1;IHS CLINICAL REPORTING;;MAY 06, 2015;Build 143
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"68084-0032-01 ")
 ;;4655
 ;;21,"68084-0032-11 ")
 ;;4656
 ;;21,"68084-0044-01 ")
 ;;4657
 ;;21,"68084-0044-11 ")
 ;;4658
 ;;21,"68084-0044-85 ")
 ;;4659
 ;;21,"68084-0045-01 ")
 ;;4660
 ;;21,"68084-0045-11 ")
 ;;4661
 ;;21,"68084-0045-85 ")
 ;;4662
 ;;21,"68084-0046-01 ")
 ;;4663
 ;;21,"68084-0046-11 ")
 ;;4664
 ;;21,"68084-0046-85 ")
 ;;4665
 ;;21,"68084-0047-01 ")
 ;;4666
 ;;21,"68084-0047-11 ")
 ;;4667
 ;;21,"68084-0047-85 ")
 ;;4668
 ;;21,"68084-0066-01 ")
 ;;4669
 ;;21,"68084-0101-01 ")
 ;;4670
 ;;21,"68084-0119-01 ")
 ;;4671
 ;;21,"68084-0119-11 ")
 ;;4672
 ;;21,"68084-0120-01 ")
 ;;4673
 ;;21,"68084-0120-11 ")
 ;;4674
 ;;21,"68084-0121-01 ")
 ;;4675
 ;;21,"68084-0121-11 ")
 ;;4676
 ;;21,"68084-0124-01 ")
 ;;4677
 ;;21,"68084-0125-01 ")
 ;;4678
 ;;21,"68084-0180-01 ")
 ;;4679
 ;;21,"68084-0180-11 ")
 ;;4680
 ;;21,"68084-0181-01 ")
 ;;4681
 ;;21,"68084-0181-11 ")
 ;;4682
 ;;21,"68084-0182-01 ")
 ;;4683
 ;;21,"68084-0182-11 ")
 ;;4684
 ;;21,"68084-0251-01 ")
 ;;4685
 ;;21,"68084-0251-11 ")
 ;;4686
 ;;21,"68084-0252-11 ")
 ;;4687
 ;;21,"68084-0252-21 ")
 ;;4688
 ;;21,"68084-0330-01 ")
 ;;4689
 ;;21,"68084-0330-11 ")
 ;;4690
 ;;21,"68084-0331-01 ")
 ;;4691
 ;;21,"68084-0331-11 ")
 ;;4692
 ;;21,"68084-0470-01 ")
 ;;4693
 ;;21,"68084-0470-11 ")
 ;;4694
 ;;21,"68084-0471-01 ")
 ;;4695
 ;;21,"68084-0471-11 ")
 ;;4696
 ;;21,"68084-0484-01 ")
 ;;4697
 ;;21,"68084-0484-11 ")
 ;;4698
 ;;21,"68084-0485-01 ")
 ;;4699
 ;;21,"68084-0485-11 ")
 ;;4700
 ;;21,"68084-0486-01 ")
 ;;4701
 ;;21,"68084-0486-11 ")
 ;;4702
 ;;21,"68084-0580-01 ")
 ;;4703
 ;;21,"68084-0580-11 ")
 ;;4704
 ;;21,"68084-0605-01 ")
 ;;4705
 ;;21,"68084-0605-11 ")
 ;;4706
 ;;21,"68084-0608-01 ")
 ;;4707
 ;;21,"68084-0608-11 ")
 ;;4708
 ;;21,"68084-0617-01 ")
 ;;4709
 ;;21,"68084-0617-11 ")
 ;;4710
 ;;21,"68084-0618-01 ")
 ;;4711
 ;;21,"68084-0618-11 ")
 ;;4712
 ;;21,"68084-0675-21 ")
 ;;4713
 ;;21,"68084-0683-01 ")
 ;;4714
 ;;21,"68084-0692-01 ")
 ;;4715
 ;;21,"68084-0698-01 ")
 ;;4716
 ;;21,"68084-0709-01 ")
 ;;4717
 ;;21,"68084-0709-11 ")
 ;;4718
 ;;21,"68084-0713-01 ")
 ;;4719
 ;;21,"68084-0737-01 ")
 ;;4720
 ;;21,"68084-0744-01 ")
 ;;4721
 ;;21,"68115-0021-60 ")
 ;;4722
 ;;21,"68115-0022-20 ")
 ;;4723
 ;;21,"68115-0023-14 ")
 ;;4724
 ;;21,"68115-0023-48 ")
 ;;4725
 ;;21,"68115-0024-90 ")
 ;;4726
 ;;21,"68115-0124-90 ")
 ;;4727
 ;;21,"68115-0143-90 ")
 ;;4728
 ;;21,"68115-0261-45 ")
 ;;4729
 ;;21,"68115-0365-45 ")
 ;;4730
 ;;21,"68115-0365-60 ")
 ;;4731
 ;;21,"68115-0366-60 ")
 ;;4732
 ;;21,"68115-0384-60 ")
 ;;4733
 ;;21,"68115-0412-00 ")
 ;;4734
 ;;21,"68115-0439-30 ")
 ;;4735
 ;;21,"68115-0445-30 ")
 ;;4736
 ;;21,"68115-0509-30 ")
 ;;4737
 ;;21,"68115-0765-30 ")
 ;;4738
 ;;21,"68115-0916-30 ")
 ;;4739
 ;;21,"68115-0919-30 ")
 ;;4740
 ;;21,"68180-0135-01 ")
 ;;4741
 ;;21,"68180-0136-01 ")
 ;;4742
 ;;21,"68180-0137-01 ")
 ;;4743
 ;;21,"68180-0294-03 ")
 ;;4744
 ;;21,"68180-0294-06 ")
 ;;4745
 ;;21,"68180-0294-07 ")
 ;;4746
 ;;21,"68180-0295-03 ")
 ;;4747
 ;;21,"68180-0295-06 ")
 ;;4748
 ;;21,"68180-0295-09 ")
 ;;4749
 ;;21,"68180-0296-03 ")
 ;;4750
 ;;21,"68180-0296-06 ")
 ;;4751
 ;;21,"68180-0296-09 ")
 ;;4752
 ;;21,"68180-0311-01 ")
 ;;4753
 ;;21,"68180-0312-01 ")
 ;;4754
 ;;21,"68180-0313-01 ")
 ;;4755
 ;;21,"68180-0314-06 ")
 ;;4756
 ;;21,"68180-0315-06 ")
 ;;4757
 ;;21,"68180-0316-06 ")
 ;;4758
 ;;21,"68180-0317-06 ")
 ;;4759
 ;;21,"68180-0351-06 ")
 ;;4760
 ;;21,"68180-0351-09 ")
 ;;4761
 ;;21,"68180-0352-01 ")
 ;;4762
 ;;21,"68180-0352-02 ")
 ;;4763
 ;;21,"68180-0352-05 ")
 ;;4764
 ;;21,"68180-0352-06 ")
 ;;4765
 ;;21,"68180-0352-09 ")
 ;;4766
 ;;21,"68180-0353-01 ")
 ;;4767
 ;;21,"68180-0353-02 ")
 ;;4768
 ;;21,"68180-0353-05 ")
 ;;4769
 ;;21,"68180-0353-06 ")
 ;;4770
 ;;21,"68180-0353-09 ")
 ;;4771
 ;;21,"68258-7003-03 ")
 ;;4772
 ;;21,"68258-7005-03 ")
 ;;4773
 ;;21,"68382-0001-01 ")
 ;;4774
 ;;21,"68382-0001-05 ")
 ;;4775
 ;;21,"68382-0001-06 ")
 ;;4776
 ;;21,"68382-0001-10 ")
 ;;4777
 ;;21,"68382-0001-16 ")
 ;;4778
 ;;21,"68382-0018-01 ")
 ;;4779
 ;;21,"68382-0018-10 ")
 ;;4780
 ;;21,"68382-0019-01 ")
 ;;4781
 ;;21,"68382-0019-10 ")
 ;;4782
 ;;21,"68382-0020-01 ")
 ;;4783
 ;;21,"68382-0020-10 ")
 ;;4784
 ;;21,"68382-0021-01 ")
 ;;4785
 ;;21,"68382-0021-10 ")
 ;;4786
 ;;21,"68382-0034-06 ")
 ;;4787
 ;;21,"68382-0034-10 ")
 ;;4788
 ;;21,"68382-0034-16 ")
 ;;4789
 ;;21,"68382-0035-06 ")
 ;;4790
 ;;21,"68382-0035-10 ")
 ;;4791
 ;;21,"68382-0035-16 ")
 ;;4792
 ;;21,"68382-0036-06 ")
 ;;4793
 ;;21,"68382-0036-10 ")
 ;;4794
 ;;21,"68382-0036-16 ")
 ;;4795
 ;;21,"68382-0097-01 ")
 ;;4796
 ;;21,"68382-0097-05 ")
 ;;4797
 ;;21,"68382-0097-06 ")
 ;;4798
 ;;21,"68382-0097-10 ")
 ;;4799
 ;;21,"68382-0097-16 ")
 ;;4800
 ;;21,"68382-0098-01 ")
 ;;4801
 ;;21,"68382-0098-05 ")
 ;;4802
 ;;21,"68382-0098-06 ")
 ;;4803
 ;;21,"68382-0098-10 ")
 ;;4804
 ;;21,"68382-0098-16 ")
 ;;4805
 ;;21,"68382-0099-01 ")
 ;;4806
 ;;21,"68382-0099-05 ")
 ;;4807
 ;;21,"68382-0099-06 ")
 ;;4808
 ;;21,"68382-0099-10 ")
 ;;4809
 ;;21,"68382-0099-16 ")
 ;;4810
 ;;21,"68382-0100-06 ")
 ;;4811
 ;;21,"68382-0101-01 ")
 ;;4812
 ;;21,"68382-0101-10 ")
 ;;4813
 ;;21,"68387-0120-30 ")
 ;;4814
 ;;21,"68387-0120-60 ")
 ;;4815
 ;;21,"68387-0120-90 ")
 ;;4816
 ;;21,"68387-0125-30 ")
 ;;4817
 ;;21,"68387-0127-30 ")
 ;;4818
 ;;21,"68387-0128-30 ")
 ;;4819
 ;;21,"68387-0160-30 ")
 ;;4820
 ;;21,"68387-0165-30 ")
 ;;4821
 ;;21,"68387-0165-90 ")
 ;;4822
 ;;21,"68387-0166-30 ")
 ;;4823
 ;;21,"68387-0166-60 ")
 ;;4824
 ;;21,"68387-0330-15 ")
 ;;4825
 ;;21,"68387-0330-30 ")
 ;;4826
 ;;21,"68387-0330-60 ")
 ;;4827
 ;;21,"68387-0335-15 ")
 ;;4828
 ;;21,"68387-0335-24 ")
 ;;4829
 ;;21,"68387-0335-30 ")
 ;;4830
 ;;21,"68387-0335-60 ")
 ;;4831
 ;;21,"68387-0335-90 ")
 ;;4832
 ;;21,"68387-0336-30 ")
 ;;4833
 ;;21,"68387-0336-90 ")
 ;;4834
 ;;21,"68387-0337-24 ")
 ;;4835
 ;;21,"68387-0337-30 ")
 ;;4836
 ;;21,"68387-0338-30 ")
 ;;4837
 ;;21,"68387-0339-30 ")
 ;;4838
 ;;21,"68387-0349-15 ")
 ;;4839
 ;;21,"68387-0349-30 ")
 ;;4840
 ;;21,"68387-0350-30 ")
 ;;4841
 ;;21,"68387-0350-60 ")
 ;;4842
 ;;21,"68387-0353-60 ")
 ;;4843
 ;;21,"68387-0360-60 ")
 ;;4844
 ;;21,"68387-0363-07 ")
 ;;4845
 ;;21,"68387-0363-15 ")
 ;;4846
 ;;21,"68387-0363-30 ")
 ;;4847
 ;;21,"68387-0553-30 ")
 ;;4848
 ;;21,"68387-0553-60 ")
 ;;4849
 ;;21,"68387-0554-30 ")
 ;;4850
 ;;21,"68387-0554-60 ")
 ;;4851
 ;;21,"68645-0130-54 ")
 ;;4852
 ;;21,"68645-0131-54 ")
 ;;4853
 ;;21,"68645-0180-54 ")
 ;;4854
 ;;21,"68645-0252-54 ")
 ;;4855
 ;;21,"68645-0282-54 ")
 ;;4856
 ;;21,"68727-0600-01 ")
 ;;4857
 ;;21,"68727-0601-01 ")
 ;;4858
 ;;21,"68968-2010-01 ")
 ;;4859
 ;;21,"68968-2020-01 ")
 ;;4860
 ;;21,"68968-2030-01 ")
 ;;4861
 ;;21,"68968-2040-01 ")
 ;;4862
 ;;21,"68968-9075-03 ")
 ;;4863
 ;;21,"76282-0206-01 ")
 ;;4864
 ;;21,"76282-0206-05 ")
 ;;4865
 ;;21,"76282-0206-10 ")
 ;;4866
 ;;21,"76282-0207-01 ")
 ;;4867
 ;;21,"76282-0207-05 ")
 ;;4868
 ;;21,"76282-0207-10 ")
 ;;4869
 ;;21,"76282-0207-30 ")
 ;;4870
 ;;21,"76282-0208-01 ")
 ;;4871
 ;;21,"76282-0208-05 ")
 ;;4872
 ;;21,"76282-0208-10 ")
 ;;4873
 ;;21,"76282-0208-30 ")
 ;;4874
 ;;21,"76282-0212-01 ")
 ;;4875
 ;;21,"76282-0212-05 ")
 ;;4876
 ;;21,"76282-0213-01 ")
 ;;4877
 ;;21,"76282-0213-05 ")
 ;;4878
 ;;21,"76282-0213-30 ")
 ;;4879
 ;;21,"76282-0214-01 ")
 ;;4880
 ;;21,"76282-0214-05 ")
 ;;4881
 ;;21,"76282-0249-90 ")
 ;;4882
 ;;21,"76282-0250-10 ")
 ;;4883
 ;;21,"76282-0250-90 ")
 ;;4884
 ;;21,"76282-0251-10 ")
 ;;4885
 ;;21,"76282-0251-90 ")
 ;;4886
 ;;9002226,798,.01)
 ;;BGP HEDIS ANTIDEPRESSANT NDC
 ;;9002226,798,.02)
 ;;@
 ;;9002226,798,.04)
 ;;n
 ;;9002226,798,.06)
 ;;@
 ;;9002226,798,.08)
 ;;@
 ;;9002226,798,.09)
 ;;3150223
 ;;9002226,798,.11)
 ;;@
 ;;9002226,798,.12)
 ;;@
 ;;9002226,798,.13)
 ;;1
 ;;9002226,798,.14)
 ;;@
 ;;9002226,798,.15)
 ;;50.67
 ;;9002226,798,.16)
 ;;@
 ;;9002226,798,.17)
 ;;@
 ;;9002226,798,3101)
 ;;@
 ;;9002226.02101,"798,00002-3004-75 ",.01)
 ;;00002-3004-75
 ;;9002226.02101,"798,00002-3004-75 ",.02)
 ;;00002-3004-75
 ;;9002226.02101,"798,00002-3230-30 ",.01)
 ;;00002-3230-30
 ;;9002226.02101,"798,00002-3230-30 ",.02)
 ;;00002-3230-30
 ;;9002226.02101,"798,00002-3231-01 ",.01)
 ;;00002-3231-01
 ;;9002226.02101,"798,00002-3231-01 ",.02)
 ;;00002-3231-01
 ;;9002226.02101,"798,00002-3231-30 ",.01)
 ;;00002-3231-30
 ;;9002226.02101,"798,00002-3231-30 ",.02)
 ;;00002-3231-30
 ;;9002226.02101,"798,00002-3231-33 ",.01)
 ;;00002-3231-33
 ;;9002226.02101,"798,00002-3231-33 ",.02)
 ;;00002-3231-33
 ;;9002226.02101,"798,00002-3232-01 ",.01)
 ;;00002-3232-01
 ;;9002226.02101,"798,00002-3232-01 ",.02)
 ;;00002-3232-01
 ;;9002226.02101,"798,00002-3232-30 ",.01)
 ;;00002-3232-30
 ;;9002226.02101,"798,00002-3232-30 ",.02)
 ;;00002-3232-30
 ;;9002226.02101,"798,00002-3232-33 ",.01)
 ;;00002-3232-33
 ;;9002226.02101,"798,00002-3232-33 ",.02)
 ;;00002-3232-33
 ;;9002226.02101,"798,00002-3233-01 ",.01)
 ;;00002-3233-01
 ;;9002226.02101,"798,00002-3233-01 ",.02)
 ;;00002-3233-01
 ;;9002226.02101,"798,00002-3233-30 ",.01)
 ;;00002-3233-30
 ;;9002226.02101,"798,00002-3233-30 ",.02)
 ;;00002-3233-30
 ;;9002226.02101,"798,00002-3233-33 ",.01)
 ;;00002-3233-33
 ;;9002226.02101,"798,00002-3233-33 ",.02)
 ;;00002-3233-33
 ;;9002226.02101,"798,00002-3234-01 ",.01)
 ;;00002-3234-01
 ;;9002226.02101,"798,00002-3234-01 ",.02)
 ;;00002-3234-01
 ;;9002226.02101,"798,00002-3234-30 ",.01)
 ;;00002-3234-30
 ;;9002226.02101,"798,00002-3234-30 ",.02)
 ;;00002-3234-30
 ;;9002226.02101,"798,00002-3234-33 ",.01)
 ;;00002-3234-33
 ;;9002226.02101,"798,00002-3234-33 ",.02)
 ;;00002-3234-33
 ;;9002226.02101,"798,00002-3235-01 ",.01)
 ;;00002-3235-01
 ;;9002226.02101,"798,00002-3235-01 ",.02)
 ;;00002-3235-01
 ;;9002226.02101,"798,00002-3235-33 ",.01)
 ;;00002-3235-33
 ;;9002226.02101,"798,00002-3235-33 ",.02)
 ;;00002-3235-33
 ;;9002226.02101,"798,00002-3235-60 ",.01)
 ;;00002-3235-60
 ;;9002226.02101,"798,00002-3235-60 ",.02)
 ;;00002-3235-60
 ;;9002226.02101,"798,00002-3237-01 ",.01)
 ;;00002-3237-01
 ;;9002226.02101,"798,00002-3237-01 ",.02)
 ;;00002-3237-01
 ;;9002226.02101,"798,00002-3237-04 ",.01)
 ;;00002-3237-04
 ;;9002226.02101,"798,00002-3237-04 ",.02)
 ;;00002-3237-04
 ;;9002226.02101,"798,00002-3237-30 ",.01)
 ;;00002-3237-30
 ;;9002226.02101,"798,00002-3237-30 ",.02)
 ;;00002-3237-30
 ;;9002226.02101,"798,00002-3237-33 ",.01)
 ;;00002-3237-33
 ;;9002226.02101,"798,00002-3237-33 ",.02)
 ;;00002-3237-33
 ;;9002226.02101,"798,00002-3240-01 ",.01)
 ;;00002-3240-01
 ;;9002226.02101,"798,00002-3240-01 ",.02)
 ;;00002-3240-01
 ;;9002226.02101,"798,00002-3240-30 ",.01)
 ;;00002-3240-30
 ;;9002226.02101,"798,00002-3240-30 ",.02)
 ;;00002-3240-30
 ;;9002226.02101,"798,00002-3240-33 ",.01)
 ;;00002-3240-33
 ;;9002226.02101,"798,00002-3240-33 ",.02)
 ;;00002-3240-33
 ;;9002226.02101,"798,00002-3240-90 ",.01)
 ;;00002-3240-90
 ;;9002226.02101,"798,00002-3240-90 ",.02)
 ;;00002-3240-90
 ;;9002226.02101,"798,00002-3270-01 ",.01)
 ;;00002-3270-01
 ;;9002226.02101,"798,00002-3270-01 ",.02)
 ;;00002-3270-01
 ;;9002226.02101,"798,00002-3270-04 ",.01)
 ;;00002-3270-04
 ;;9002226.02101,"798,00002-3270-04 ",.02)
 ;;00002-3270-04
 ;;9002226.02101,"798,00002-3270-30 ",.01)
 ;;00002-3270-30
 ;;9002226.02101,"798,00002-3270-30 ",.02)
 ;;00002-3270-30
 ;;9002226.02101,"798,00002-3270-33 ",.01)
 ;;00002-3270-33
 ;;9002226.02101,"798,00002-3270-33 ",.02)
 ;;00002-3270-33
 ;;9002226.02101,"798,00007-4471-20 ",.01)
 ;;00007-4471-20
 ;;9002226.02101,"798,00007-4471-20 ",.02)
 ;;00007-4471-20
 ;;9002226.02101,"798,00008-0701-08 ",.01)
 ;;00008-0701-08
 ;;9002226.02101,"798,00008-0701-08 ",.02)
 ;;00008-0701-08
 ;;9002226.02101,"798,00008-0703-07 ",.01)
 ;;00008-0703-07
 ;;9002226.02101,"798,00008-0703-07 ",.02)
 ;;00008-0703-07
 ;;9002226.02101,"798,00008-0704-07 ",.01)
 ;;00008-0704-07
 ;;9002226.02101,"798,00008-0704-07 ",.02)
 ;;00008-0704-07
 ;;9002226.02101,"798,00008-0705-07 ",.01)
 ;;00008-0705-07
 ;;9002226.02101,"798,00008-0705-07 ",.02)
 ;;00008-0705-07
 ;;9002226.02101,"798,00008-0781-08 ",.01)
 ;;00008-0781-08
 ;;9002226.02101,"798,00008-0781-08 ",.02)
 ;;00008-0781-08
 ;;9002226.02101,"798,00008-0833-02 ",.01)
 ;;00008-0833-02
 ;;9002226.02101,"798,00008-0833-02 ",.02)
 ;;00008-0833-02
 ;;9002226.02101,"798,00008-0833-03 ",.01)
 ;;00008-0833-03
 ;;9002226.02101,"798,00008-0833-03 ",.02)
 ;;00008-0833-03
 ;;9002226.02101,"798,00008-0833-20 ",.01)
 ;;00008-0833-20
 ;;9002226.02101,"798,00008-0833-20 ",.02)
 ;;00008-0833-20
 ;;9002226.02101,"798,00008-0833-21 ",.01)
 ;;00008-0833-21
 ;;9002226.02101,"798,00008-0833-21 ",.02)
 ;;00008-0833-21
 ;;9002226.02101,"798,00008-0833-22 ",.01)
 ;;00008-0833-22
 ;;9002226.02101,"798,00008-0833-22 ",.02)
 ;;00008-0833-22
 ;;9002226.02101,"798,00008-0836-02 ",.01)
 ;;00008-0836-02
 ;;9002226.02101,"798,00008-0836-02 ",.02)
 ;;00008-0836-02