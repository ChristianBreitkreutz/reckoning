require 'test_helper'

class InvoiceMailerTest < ActionMailer::TestCase
  fixtures [:invoices, :customers, :users, :projects, :positions]

  let(:invoice) { invoices :january }

  before do
    invoice.customer.email_template = "Hallo Foo"
    invoice.customer.invoice_email = "test@customer.io"
    invoice.customer.save

    invoice.generate
  end

  after do
    # File.unlink(invoice.pdf_path)
  end

  describe "#customer_mail" do
    it "sends email to default from if nothing is defined" do
      mail = InvoiceMailer.customer_mail(invoice).deliver

      refute ActionMailer::Base.deliveries.empty?

      assert_equal ["test@customer.io"], mail.to
      assert_equal ["noreply@reckoning.io"], mail.from
    end

    it "sends email to global from address" do
      invoice.user.default_from = "user@reckoning.io"
      invoice.user.save

      mail = InvoiceMailer.customer_mail(invoice).deliver

      refute ActionMailer::Base.deliveries.empty?

      assert_equal ["test@customer.io"], mail.to
      assert_equal ["user@reckoning.io"], mail.from
    end

    it "sends email to customer from address" do
      invoice.customer.default_from = "special-customer@reckoning.io"
      invoice.customer.save

      mail = InvoiceMailer.customer_mail(invoice).deliver

      refute ActionMailer::Base.deliveries.empty?

      assert_equal ["test@customer.io"], mail.to
      assert_equal ["special-customer@reckoning.io"], mail.from
    end

    it "falls back to default from address if global email is empty string" do
      invoice.user.default_from = ""
      invoice.user.save

      mail = InvoiceMailer.customer_mail(invoice).deliver

      refute ActionMailer::Base.deliveries.empty?

      assert_equal ["test@customer.io"], mail.to
      assert_equal ["noreply@reckoning.io"], mail.from
    end
  end
end
