# coding: utf-8
require 'date'

Shoes.app :width => 900, :height => 600, :margin => 10 do    
  @users = [
      {id: 1, username: 'bbonamin', password: '123'},
      {id: 2, username: 'pancheto', password: '456'},
      {id: 3, username: 'magneto', password: '789'}
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
        answer = ask("Usuario: ")
        user = @users.select{|user| user[:username] == answer}.first
        if user.nil?
          alert('Usuario no valido')
        else
          password = ask('Codigo')
          if user[:password] == password
            open_shift = @shifts.select{|shift| shift[:user_id] == user[:id] && shift[:end_date] == nil}.first
            if open_shift.nil?
              new_shift = {user_id: user[:id], start_date: Time.now, end_date: nil}
              @shifts << new_shift
              refresh_users_and_shifts
            else
              alert 'Ya hay un turno abierto!'
            end
          else
            alert 'Error de autenticación!'
          end
        end
      end
    end

    stack width: '50%' do
      button "Salida" do
        answer ask("Código: ")
      end
    end
  end

  flow width: 900, margin: 10 do
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
    end
    stack width: '100%' do
      subtitle 'Turnos'
      @gui_shifts = para
    end
  end
  
  def delete_user(user)
    @users.delete user
    refresh_users_and_shifts
  end

  def delete_shift(shift)
    @shifts.delete shift
    refresh_users_and_shifts
  end

  def refresh_users_and_shifts
    @gui_users.replace *(
      @users.map { |user|
        [ user[:username], '  ', user[:password] ] + [ link('Borrar') { delete_user user } ] + [ "\n" ]
      }.flatten
    )
    @gui_shifts.replace *(
      @shifts.map { |shift|
        [ shift[:user_id], '  ', shift[:start_date], ' ', shift[:end_date] ] + [ link('Borrar') { delete_shift shift } ] + [ "\n" ]
      }.flatten
    )
  end

  def add_user
    new_user = {id: @users.last[:id] + 1, username: @username.text, password: @password.text}

    @users << new_user
    @username.text, @password.text = nil
    refresh_users_and_shifts
  end

  refresh_users_and_shifts
end
