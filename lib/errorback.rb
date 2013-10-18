class Errorback < Callback

  private
  def run_promise(reason)
    @thenable.reject(reason)
  end

end