ScBackendSetting.seed_once(:backend_code, :service_code, :app_id) do |s|
  s.backend_code = 'FCR'
  s.service_code = 'FT'
  s.app_id = nil
  s.setting1_name = 'userId'
  s.setting1_type = 'text'
  s.setting1_value = 'EXCHUSER'

  s.created_by = 'Q'
  s.created_at = Time.zone.now
  s.approval_status = 'A'
end

ScBackendSetting.seed_once(:backend_code, :service_code, :app_id) do |s|
  s.backend_code = 'ATOM'
  s.service_code = 'FT'
  s.app_id = nil
  s.setting1_name = 'vendorId'
  s.setting1_type = 'text'
  s.setting1_value = 'ESBU0010'
  s.setting2_name = 'vendorPassword'
  s.setting2_type = 'text'
  s.setting2_value = '6d4946909'

  s.created_by = 'Q'
  s.created_at = Time.zone.now
  s.approval_status = 'A'
end

ScBackendSetting.seed_once(:backend_code, :service_code, :app_id) do |s|
  s.backend_code = 'FCR'
  s.service_code = 'BPS'
  s.app_id = nil
  s.setting1_name = 'userId'
  s.setting1_type = 'text'
  s.setting1_value = nil
  s.setting2_name = 'narrativePrefix'
  s.setting2_type = 'text'
  s.setting2_value = nil
  s.created_by = 'Q'
  s.created_at = Time.zone.now
  s.approval_status = 'A'
end

