module FundsTransferCustomersHelper
  def find_funds_transfer_customers(params)
    funds_transfer_customers = (params[:approval_status].present? and params[:approval_status] == 'U') ? FundsTransferCustomer.unscoped : FundsTransferCustomer
    funds_transfer_customers = funds_transfer_customers.where("name LIKE ?","#{params[:name].upcase}%") if params[:name].present?
    funds_transfer_customers = funds_transfer_customers.where("app_id=?",params[:app_id]) if params[:app_id].present?
    funds_transfer_customers
  end
  
  def get_allowed_relns(ft_customer)
    if ft_customer.allowed_relns.empty?
      if ft_customer.is_retail == 'Y'
        return "GUR, JOF, JOO, SOW, TRU"
      else
        return "GUR, JOF, JOO, SOW, TRU, AUS"
      end
    else
      return ft_customer.allowed_relns.join(', ')
    end
  end

  def options_for_notify_app_code
    sc_service_id = ScService.find_by(code: 'FUNDSTRANSFER').try(:id)
    sc_service_id.present? ? NsCallback.where(sc_service_id: sc_service_id).map { |key, value| [key.app_code, key.app_code]} : []
  end
end
