# EmailValidation

require 'resolv'

module EmailValidation
  EMAIL_PATTERN = /(\S+)@(\S+)/
  SERVER_TIMEOUT = 3 # seconds

  def valid_domain?(email)
    domain = email.match(EMAIL_PATTERN)[2]

    dns = Resolv::DNS.new

    Timeout::timeout(SERVER_TIMEOUT) do
      # Check the MX records
      mx_records =
        dns.getresources(domain, Resolv::DNS::Resource::IN::MX)

      mx_record.sort_by { |mx| mx.preference }.each do |mx|
        a_records = dns.getresources(mx.exchange.to_s,
                                     Resolv::DNS::Resource::IN::A)
        return true if a_records.any?
      end

      # Try a stratight A record
      a_records = dns.getresources(domain, Resolv::DNS::Resource::IN::A)
      a_records.any?
    end
  rescue Timeout::Error, Errno::ECONNREFUSED
    false
  end

end

