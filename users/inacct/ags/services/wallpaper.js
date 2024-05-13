import Gio from 'gi://Gio';
import { SearchDir } from '../utils.js';

const cache_folder = `${Utils.HOME}/.cache/swww/`
const wallpaper_folder = `${Utils.HOME}/Pictures/Wallpapers/`

class Wallpaper extends Service {
  static {
    Service.register(
      this,
      {},
      {
        current: ['jsobject', 'r'],
        available: ['jsobject', 'r'],
      },
    )
  }

  #_current = new Map(SearchDir(cache_folder)
    .map(entry => [entry, Utils.readFile(cache_folder + entry)]))
  #_available = SearchDir(wallpaper_folder)

  get current() {return this.#_current}
  get available() {return this.#_available}

  setBackground(path, monitors = null) {
    // If monitors is an array, turn it into a string
    if (monitors instanceof Array)
      monitors.toString()
    Utils.execAsync([
        'swww', 'img',
        '--transition-type', 'wipe',
        '--transition-angle', '90',
        '--transition-bezier', '0,0,.58,1',
        ...(monitors ? ['--outputs', monitors,] : []),
        path
    ]).catch(err => console.warn(err))
    // Folder monitors do the rest
  }

  constructor() {
    super()

    Utils.monitorFile(cache_folder, (file, event) => {
      const monitor_name = file.get_basename()
      const image_path = Utils.readFile(file)
      switch (event) {
        case Gio.FileMonitorEvent.CHANGES_DONE_HINT:
          this.#_current.set(monitor_name, image_path)
          this.changed('current')
          break
        case Gio.FileMonitorEvent.DELETED:
          this.#_current.delete(monitor_name)
          this.changed('current')
          break
      }
    })

    Utils.monitorFile(wallpaper_folder, (file, event) => {
      switch (event) {
        case Gio.FileMonitorEvent.CHANGES_DONE_HINT:
          this.#_available = SearchDir(wallpaper_folder)
          this.changed('available')
          break
        case Gio.FileMonitorEvent.DELETED:
          this.#_available = this.#_available.filter(value => value !== file.get_basename())
          this.changed('available')
          break
      }
    })
  }
}

export default new Wallpaper
