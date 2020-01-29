def get_command_line_argument
  # ARGV is an array that Ruby defines for us,
  # which contains all the arguments we passed to it
  # when invoking the script from the command line.
  # https://docs.ruby-lang.org/en/2.4.0/ARGF.html
  if ARGV.empty?
    puts "Usage: ruby lookup.rb <domain>"
    exit
  end
  ARGV.first
end

# `domain` contains the domain name we have to look up.
domain = get_command_line_argument

# File.readlines reads a file and returns an
# array of string, where each element is a line
# https://www.rubydoc.info/stdlib/core/IO:readlines
dns_raw = File.readlines("zone")

def parse_dns(dns_raw)
  dns_records=[]
  dns_raw.reject!{|item| item.strip.empty?}
  dns_raw.reject! { |item| item.strip.start_with?('#') }
  dns_raw.each do |item|
    dns_records<<item.split(", ")
  end
  return dns_records
end



def resolve(dns_records,lookup_chain,domain)  
  dns_records.each do|item|
    if item[1].eql? domain  
      if item[0].eql? "A" 
        lookup_chain<<item[2]
        return lookup_chain
      elsif item[0].eql? "CNAME"
        return resolve(dns_records, lookup_chain<<item[2].strip, item[2].strip)
      end
    end  
  end
  return ["Error: record not found for "+domain]
end 





# To complete the assignment, implement `parse_dns` and `resolve`.
# Remember to implement them above this line since in Ruby
# you can invoke a function only after it is defined.
dns_records = parse_dns(dns_raw)
lookup_chain = [domain]
lookup_chain = resolve(dns_records, lookup_chain, domain)
puts lookup_chain.join(" => ")
