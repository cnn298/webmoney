module Webmoney::RequestResult    # :nodoc:all

  def result_check_sign(doc)
    doc.at('//testsign/res').inner_html == 'yes' ? true : false
  end

  def result_get_passport(doc)
    tid = doc.at('/response/certinfo/attestat/row')['tid'].to_i
    recalled = doc.at('/response/certinfo/attestat/row')['recalled'].to_i
    locked = doc.at('/response/certinfo/userinfo/value/row')['locked'].to_i
    { # TODO more attestat fields...
      :attestat => ( recalled + locked > 0) ? Webmoney::Passport::ALIAS : tid,
      :created_at => Time.xmlschema(doc.at('/response/certinfo/attestat/row')['datecrt'])
    }
  end

  def result_bussines_level(doc)
    doc.at('//level').inner_html.to_i
  end

  def result_send_message(doc)
    time = doc.at('//message/datecrt').inner_html
    m = time.match(/(\d{4})(\d{2})(\d{2}) (\d{2}):(\d{2}):(\d{2})/)
    time = Time.mktime(*m[1..6])
    { :id => doc.at('//message')['id'], :date => time }
  end

  def result_find_wm(doc)
    {
      :retval => doc.at('//retval').inner_html.to_i,
      :wmid   => (doc.at('//testwmpurse/wmid').inner_html rescue nil),
      :purse  => (doc.at('//testwmpurse/purse').inner_html rescue nil)
    }
  end

end