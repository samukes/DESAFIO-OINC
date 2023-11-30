defmodule DesafioOinc.App do
  use Commanded.Application, otp_app: :desafio_oinc

  router(DesafioOinc.Router)
end
