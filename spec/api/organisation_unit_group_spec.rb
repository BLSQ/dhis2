# frozen_string_literal: true

RSpec.describe Dhis2::Api::Analytic do
  it "shoud expose organisation_unit_ids" do
    stub_request(:get, "https://play.dhis2.org/demo/api/organisationUnitGroups/id1")
      .to_return(status: 200, body: fixture_content(:dhis2, "organisation_unit_group.json"))

    group = Dhis2.client.organisation_unit_groups.find("id1")
    
    expect(group.organisation_unit_ids).to eq %w[
      EURoFVjowXs NMcx2jmra3c p9KfD6eaRvu L5gENbBNNup E497Rk80ivZ
      scc4QyxenJd uFp0ztDOFbI W7ekX3gi0ut TEVtOFKcLAP yMCshbaVExv
      d9zRBAoM8OC ua5GXy2uhBR sM0Us0NkSez p310xqwAJge DMxw0SASFih
      azRICFoILuh FLjwMPWLrL2 FclfbEFMcf3 wtdBuXDwZYQ agM0BKQlTh3
      m5BX6CvJ6Ex NjyJYiIuKIG xKaB8tfbTzm Jiymtq0A01x tO01bqIipeD
      EUUkKEDoNsf ke2gwHKHP3z aSxNNRxPuBP Qc9lf4VM9bD FNnj3jKGS7i
      OjXNuYyLaCJ ubsjwFFBaJM ZdPkczYqeIY cNAp6CJeLxk sIVFEyNfOg4
      Umh4HKqqFp6 aHs9PLxIdbr Ahh47q8AkId D2rB1GRuh8C N3tpEjZcPm9
      MpcMjLmbATv UOJlcpPnBat vELbGdEphPd P4upLKrpkHP X79FDd4EAgo
      TljiT6C5D0J PaNv9VyD06n pNPmNeqyrim PduUQmdt0pB sesv0eXljBq
      RQgXBKxgvHf o0BgK1dLhF8 TSyzvBiovKh DiszpKrYNg8 wUmVUKhnPuy
      iMZihUMzH92 ii2KMnWMx2L Gm7YUjhVi9Q r5WWF9WDzoa iOA3z6Y3cq5
      TjZwphhxCuV NRPCjDljVtu PC3Ag91n82e CvBAqD6RzLZ FbD5Z8z22Yb
      a04CZxe0PSe egjrZ1PHNtT mwN7QuEfT8m qIpBLa1SCZt OY7mYDATra3
      tSBcgrTDdB8 VhRX5JDVo7R H97XE5Ea089 HWXk4EBHUyk bPqP6eRfkyn
      RAsstekPRco inpc5QsFRTm e2WgqiasKnD k1Y0oNqPlmy EH0dXLB4nZg
      O1KFJmM6HUx qVvitxEF2ck PQEpIeuSTCN GHHvGp7tgtZ mepHuAA9l51
      gUPhNWkSXvD aIsnJuZbmVA dQggcljEImF k6lOze3vTzP RhJbg8UD75Q
      HcB2W6Fgp7i mzsOsz0NwNY m0XorV4WWg0 EXbPGmEUdnc CKkE4GBJekz
      Z9ny6QeqsgX uedNhvYPMNu nv41sOz8IVM U4FzUXMvbI8 gE3gEGZbQMi
      MuZJ8lprGqK NaVzm59XKGf uDzWmUDHKeR HQoxFu4lYPS q56204kKXgZ
      JQJjsXvHE5M KiheEgvUZ0i J42QfNe0GJZ uRQj8WRK0Py KYXbIQBQgP1
      SnCrOCRrxGX O63vIA5MVn6 kUzpbgPCwVA oRncQGhLYNE QZtMuEEV9Vv
      PuZOFApTSeo LnToY3ExKxL HNv1aLPdMYb CFPrsD3dNeb qxbsDd9QYv6
      lxxASQqPUqd pJv8NJlJNhU m3VnSQbE8CD Ep5iWL1UKvF rm60vuHyQXj
      amgb83zVxp5 g5A3hiJlwmI IlnqGuxfQAw Q2USZSJmcNK KcCbIDzRcui
      MXdbul7bBqV lpQvlm9czYE bHcw141PTsE bSj2UnYhTFb U514Dz4v9pv
      jGYT5U5qJP6 xa4F6gesVJm IlMQTFvcq9r L4Tw4NlaMjn sLKHXoBIqSs
      va2lE4FiVVb PA1spYiNZfv YAuJ3fyoEuI roGdTjEqLZQ k8ZPul89UDm
      kuqKh33SPgg QzPf0qKBU4n K00jR5dmoFZ mt47bcb0Rcj K6oyIMh7Lee
      lL2LBkhlsmV W2KnxOMvmgE hzf90qz08AW w3mBVfrWhXl mshIal30ffW
      pXDcgDRz8Od n7wN9gMFfZ5 BNFrspDBKel cw0Wm1QTHRq Jyv7sjpl9bA
      KKoPh1lDd9j Luv2kmWWgoG zuXW98AEbE7 Yj2ni275yPJ cMFi8lYbXHY
      jhtj3eQa1pM sznCEDMABa2 zEsMdeJOty4 K3jhn3TXF3a s5aXfzOL456
      dkmpOuVhBba TmCsvdJLHoX jKZ0U8Og5aV DvzKyuC0G4w fAsj6a4nudH
      QsAwd531Cpd g5lonXJ9ndA lOv6IFgr6Fs YvwYw7GilkP PMsF64R6OJX
      g10jm7jPdzf wByqtWCCuDJ PcADvhvcaI2 zQpYVEyAM2t oLuhRyYPxRO
      Y8foq27WLti nX05QLraDhO QpRIPul20Sb xMn4Wki9doK RaQGHRti7JM
      JrSIoCOdTH2 agEKP19IUKI Mi4dWRtfIOC rCKWdLr4B8K
    ]
  end

  describe "#create" do
    it "shoud expose map ou groups" do
      stub_request(:post, "https://play.dhis2.org/demo/api/metadata")
        .with(body: "{\"organisationUnitGroups\":[{\"name\":\"oug_name\",\"shortName\":\"oug_short_name\",\"code\":\"code\"}]}")
        .to_return(status: 200, body: "", headers: {})

      status = Dhis2.client.organisation_unit_groups.create(
        [
          {
            name:       "oug_name",
            short_name: "oug_short_name",
            code:       "code"
          }
        ]
      )

      expect(status).to be_a(Dhis2::Status)
    end
  end
end
