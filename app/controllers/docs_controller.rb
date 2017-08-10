class DocsController < ApplicationController
  def waiver
    send_file("public/waiver.pdf", type: "application/pdf")
  end
end
