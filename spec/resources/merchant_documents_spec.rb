# frozen_string_literal: true

require "spec_helper"

RSpec.describe SatsRail::Resources::MerchantDocuments do
  it "lists documents" do
    stub_request(:get, "#{base_url}/m/merchant_documents")
      .to_return(**json_response(object: "list", data: []))
    client.merchant_documents.list
  end

  it "retrieves a document" do
    stub_request(:get, "#{base_url}/m/merchant_documents/doc_1")
      .to_return(**json_response(object: "merchant_document", id: "doc_1"))
    expect(client.merchant_documents.retrieve("doc_1")["id"]).to eq("doc_1")
  end

  it "does not expose create or delete (admin-only)" do
    expect(client.merchant_documents).not_to respond_to(:create)
    expect(client.merchant_documents).not_to respond_to(:delete)
  end
end
