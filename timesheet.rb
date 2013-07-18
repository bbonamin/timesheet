require 'date'

Shoes.app :width => 250, :height => 600, :margin => 10 do    
  @users = [
      {id: 1, username: 'bbonamin', password: '123'},
      {id: 2, username: 'pancheto', password: '456'},
      {id: 3, username: 'magnetto', password: '789'}
    ]

  @shifts = [
      {user_id: 1, start_date: Time.now, end_date: Time.now},
      {user_id: 1, start_date: Time.now, end_date: Time.now},
      {user_id: 2, start_date: Time.now, end_date: Time.now},
      {user_id: 2, start_date: Time.now, end_date: Time.now},
      {user_id: 3, start_date: Time.now, end_date: Time.now},
      {user_id: 3, start_date: Time.now, end_date: Time.now}
    ]

  flow width: 240, margin: 10 do
    title 'Timesheet'
    stack width: '50%' do
      button "Entrada" do
        answer ask("Código: ")
      end
    end

    stack width: '50%' do
      button "Salida" do
        answer ask("Código: ")
      end
    end
  end

  flow width: 240, margin: 10 do
    title 'Admin'
    stack width: '100%' do
      subtitle 'Usuarios'

      @gui_users = para

      subtitle "Agregar..."
      para 'Usuario'
      @username = edit_line
      para 'Codigo'
      @password = edit_line
      
      button 'Agregar...' do
        add_user
      end

  #   button "Exportar datos" do
  #     answer ask("Código: ")
  #   end

    end
  end
  
  def delete_user(user)
    @users.delete user
    refresh_users
  end

  def refresh_users
    @gui_users.replace *(
      @users.map { |user|
        [ user[:username], '  ' ] + [ link('Borrar') { delete_user user } ] + [ "\n" ]
      }.flatten
    )
  end

  def add_user
    new_user = {id: @users.last[:id] + 1, username: @username.text, password: @password.text}

    @users << new_user
    @username.text, @password.text = nil
    refresh_users
  end

  

  def answer(v)
    @answer.replace v.inspect
  end

  refresh_users
end
