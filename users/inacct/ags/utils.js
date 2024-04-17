// Misc Utility Functions
import GLib from "gi://GLib"

/**
 * Constructor for Bar containers
 * @param {Array} children
 * @param {Object} props
 */
export const BarBox = (children, props = {}) => Widget.Box({
    ...props,
    class_name: "bar-widget",
    children: children,
})

/**
 * Capitalize first letter of word
 * @param {String} str
 */
export function Capitalize(str) {return str.charAt(0).toUpperCase() + str.slice(1)}

/**
 * Current distro
 */
export const distro = GLib.get_os_info("ID")

/**
 * Standardized array of icons
 */
export const icons = Object.freeze({
    configure: "configure",
    tick: "object-select-symbolic",
    exit: "window-close-symbolic",
    trash: "user-trash-symbolic",
    notification: "notification-symbolic",
    notification_empty: "notifications-disabled-symbolic",
    search: "folder-saved-search-symbolic",
    network: {
        offline: "network-wired-offline",
        wired: "network-wired-symbolic",
        wireless: {
            weak: "network-wireless-signal-weak",
            ok: "network-wireless-signal-ok",
            good: "network-wireless-signal-good",
            excellent: "network-wireless-signal-excellent"
        }
    },
    audio: {
        mic: {
            muted: "microphone-sensitivity-muted-symbolic",
            low: "microphone-sensitivity-low-symbolic",
            medium: "microphone-sensitivity-medium-symbolic",
            high: "microphone-sensitivity-high-symbolic",
        },
        volume: {
            muted: "audio-volume-muted-symbolic",
            low: "audio-volume-low-symbolic",
            medium: "audio-volume-medium-symbolic",
            high: "audio-volume-high-symbolic",
        },
        headphones: "audio-headphones-symbolic",
        equalizer: "view-media-equalizer"
    },
    power: {
        shutdown: "system-shutdown-symbolic",
    }
})
