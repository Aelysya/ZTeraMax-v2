module PFM
  class Pokemon
    # List of items (in the form index order) that change the form of Ogerpon
    OGERPON_TERA_TYPE = %i[grass water fire rock]

    # Determine the form of Ogerpon
    # @param reason [Symbol]
    def ogerpon_form(reason)
      form = OGERPONMASK.index(item_db_symbol).to_i
      change_tera_type(OGERPON_TERA_TYPE[form])

      form += 4 if reason == :terastal

      return form
    end

    # Determine the form of Terapagos
    # @param reason [Symbol]
    def terapagos_form(reason)
      return 1 if reason == :battle
      return 2 if reason == :terastal

      return 0
    end

    FORM_CALIBRATE[:terapagos] = proc { |reason| @form = terapagos_form(reason) }
    FORM_CALIBRATE[:ogerpon] = proc { |reason| @form = ogerpon_form(reason) }
  end
end
