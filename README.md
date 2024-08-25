**Faders Module Documentation**

---

### **`Faders:Create(Instance)`**

Creates a new fader for the specified Roblox `Instance` and its descendants. This method gathers all eligible properties that can be faded (such as `BackgroundTransparency`, `TextTransparency`, `Transparency`, `PlaceholderColor3`, etc.) and stores their initial and target states. It returns a `FaderBase` object that can be used to control the fade animations for the `Instance`.

- **Parameters**:
  - `Instance`: The Roblox `Instance` you want to apply fading to (and its descendants).
- **Returns**: A `FaderBase` object with methods to control fading animations.

### **`FaderBase:Play(Direction, FadeInfo)`**

Starts playing the fade animation for the `FaderBase` object in the specified direction. 

- **Parameters**:
  - `Direction`: Can be `"In"` (fade to visible) or `"Out"` (fade to invisible).
  - `FadeInfo`: TweenInfo object or a number (duration in seconds). Determines how the fade animation will be executed.

### **`FaderBase:Pause()`**

Pauses the ongoing fade animation for the `FaderBase` object. Useful when you need to temporarily halt the fade without stopping it completely.

- **Parameters**: None.

### **`FaderBase:Resume()`**

Resumes a paused fade animation from where it left off. This method is useful for continuing animations that were previously paused.

- **Parameters**: None.

### **`FaderBase:Cancel()`**

Stops the fade animation for the `FaderBase` object and resets the properties to their original state. This is useful when you want to completely abort the fading process.

- **Parameters**: None.

### **`Faders:Play(Fader, Direction, FadeInfo)`**

Directly plays a fade animation for a given fader in a specified direction with specified tween settings. This method manages the coroutine responsible for running the fade animation smoothly.

- **Parameters**:
  - `Fader`: The `FaderBase` object representing the `Instance` to fade.
  - `Direction`: Can be `"In"` or `"Out"`.
  - `FadeInfo`: TweenInfo object or a number (duration in seconds).

### **`Faders:Pause(Fader)`**

Pauses all active tweens for the given `Fader`. This is helpful if you need to temporarily halt animations without completely stopping them.

- **Parameters**:
  - `Fader`: The `FaderBase` object whose animations you want to pause.

### **`Faders:Resume(Fader)`**

Resumes all paused tweens for the given `Fader`. Allows you to continue an animation from where it was paused.

- **Parameters**:
  - `Fader`: The `FaderBase` object whose animations you want to resume.

### **`Faders:Cancel(Fader)`**

Cancels the ongoing fade animation for the given `Fader` and stops all associated tweens. This is useful for abruptly stopping the fade animation and ensuring no animations are left running.

- **Parameters**:
  - `Fader`: The `FaderBase` object whose animations you want to cancel.

### **`Faders:Destroy(Fader)`**

Destroys the given `Fader` and cleans up all associated resources. This method ensures that all tweens are paused, destroyed, and that no memory leaks occur by clearing all references.

- **Parameters**:
  - `Fader`: The `FaderBase` object you want to destroy.

---

**Notes:**
- The `FaderBase` object returned by `Faders:Create` is your primary tool for managing animations. Use the methods on this object to control fade animations interactively.
- Always call `Faders:Destroy` when you no longer need a fader to ensure proper cleanup and avoid memory leaks.
