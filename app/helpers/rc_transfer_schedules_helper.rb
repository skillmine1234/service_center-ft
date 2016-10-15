module RcTransferSchedulesHelper
  def find_rc_transfer_schedules(params)
    rc_transfer_schedules = (params[:approval_status].present? and params[:approval_status] == 'U') ? RcTransferSchedule.unscoped : RcTransferSchedule
    rc_transfer_schedules = rc_transfer_schedules.where("is_enabled=?",params[:is_enabled]) if params[:is_enabled].present?
    rc_transfer_schedules = rc_transfer_schedules.where("code = ?", params[:code]) if params[:code].present?
    rc_transfer_schedules = rc_transfer_schedules.where("bene_account_no=?",params[:bene_account_no]) if params[:bene_account_no].present?
    rc_transfer_schedules = rc_transfer_schedules.where("debit_account_no=?",params[:debit_account_no]) if params[:debit_account_no].present?
    rc_transfer_schedules = rc_transfer_schedules.where("notify_mobile_no=?",params[:notify_mobile_no]) if params[:notify_mobile_no].present?
    rc_transfer_schedules = rc_transfer_schedules.where("next_run_at>=?",Time.zone.parse(params[:next_from_date])) if params[:next_from_date].present?
    rc_transfer_schedules = rc_transfer_schedules.where("next_run_at<=?",Time.zone.parse(params[:next_to_date])) if params[:next_to_date].present?
    rc_transfer_schedules = rc_transfer_schedules.where("last_run_at>=?",Time.zone.parse(params[:last_from_date])) if params[:last_from_date].present?
    rc_transfer_schedules = rc_transfer_schedules.where("last_run_at<=?",Time.zone.parse(params[:last_to_date])) if params[:last_to_date].present?
    rc_transfer_schedules
  end
end
