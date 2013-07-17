Shoes.app :width => 250, :height => 150, :margin => 10 do
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
  
  def answer(v)
    @answer.replace v.inspect
  end

  

  @answer = para "Answer"
end
