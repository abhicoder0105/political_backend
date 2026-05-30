class CreateMobileOtpVerifications < ActiveRecord::Migration[8.1]
  def change
    create_table :mobile_otp_verifications do |t|
      t.string :phone_number
      t.string :otp_digest
      t.datetime :expires_at
      t.datetime :verified_at
      t.integer :attempts_count
      t.integer :resend_count
      t.datetime :last_sent_at
      t.string :purpose
      t.string :ip_address

      t.timestamps
    end
  end
end
