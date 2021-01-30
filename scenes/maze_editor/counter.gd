extends Label
signal go

func _ready():
    self.set_text("59")
    set_process_input(true)
    $Timer.start()

func _input(event):
    if(event.is_pressed() and not event.is_echo()):
        var n = int(self.get_text())
        self.set_text(str(n-1))
        print("hue")

func _on_Timer_timeout():
    var n = int(self.get_text()) #.split(":")[1]
    if(n == 0):
        $Timer.stop()
        emit_signal("go")
    else:
        self.set_text(str(n-1))
