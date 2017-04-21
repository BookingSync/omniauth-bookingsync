shared_examples "an oauth2 strategy" do
  describe "#client" do
    let(:options) do
      { client_options: { "authorize_url" => "https://example.com" } }
    end

    it "is initialized with symbolized client_options" do
      expect(strategy.client.options[:authorize_url]).to eq "https://example.com"
    end
  end

  describe "#authorize_params" do
    context "when passed as authorize_params" do
      let(:options) do
        { authorize_params: { foo: "bar", baz: "zip" } }
      end

      it "includes any authorize params passed in the :authorize_params option" do
        expect(strategy.authorize_params["foo"]).to eq("bar")
        expect(strategy.authorize_params["baz"]).to eq("zip")
      end
    end

    context "when passed as authorize_options" do
      let(:options) do
        { authorize_options: [:scope, :foo], scope: "bar", foo: "baz" }
      end

      it "includes top-level options that are marked as :authorize_options" do
        expect(strategy.authorize_params["scope"]).to eq("bar")
        expect(strategy.authorize_params["foo"]).to eq("baz")
      end
    end
  end

  describe "#token_params" do
    context "when passed as token_params" do
      let(:options) do
        { token_params: { foo: "bar", baz: "zip" } }
      end

      it "includes any token params passed in the :token_params option" do
        expect(strategy.token_params["foo"]).to eq("bar")
        expect(strategy.token_params["baz"]).to eq("zip")
      end
    end

    context "when passed as token_options" do
      let(:options) do
        { token_options: [:scope, :foo], scope: "bar", foo: "baz" }
      end

      it "includes top-level options that are marked as :token_options" do
        expect(strategy.token_params["scope"]).to eq("bar")
        expect(strategy.token_params["foo"]).to eq("baz")
      end
    end
  end
end
