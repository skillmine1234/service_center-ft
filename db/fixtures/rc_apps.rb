RcApp.seed(:app_id) do |s|
  s.app_id = 'VODAFONE'
  s.url = 'http://182.19.20.182:81/mcommerce.webservices/pgService'
  s.setting1_name  = 'username'
  s.setting1_type  = 'text'
  s.setting1_value = '2UyVFO+gxMM1veAt7Ehzgw=='
  s.setting2_name  = 'password'
  s.setting2_type  = 'text'
  s.setting2_value = 'z5xVCbkuR6EsM4W/BU3CNg=='
  s.created_by = 'Q'
  s.approval_status = 'A'
end

RcApp.seed(:app_id) do |s|
  s.app_id = 'RELIANCE'
  s.url = 'https://ecollection.ril.com/BankPymtWS/service.asmx'
  s.http_username = 'BkPymtUsr'
  s.http_password = 'ecol@12345'
  s.udf1_name  = 'beneficiary_identification_code'
  s.udf1_type  = 'text'
  s.udf2_name  = 'remitter_identification_code'
  s.udf2_type  = 'text'
  s.created_by = 'Q'
  s.approval_status = 'A'
end
