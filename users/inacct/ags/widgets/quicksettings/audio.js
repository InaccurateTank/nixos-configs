import { icons } from "../../utils.js"
import SubMenu from "./submenu.js"

const audio = await Service.import('audio')

const audioType = (type) => type === "sink"  ? "speaker" : "microphone"
const audioTypes = (type) => type === "sink" ? "speakers" : "microphones"

const VolumeIcon = (type) => {
    const volume = audio[audioType(type)].is_muted ? 0 : audio[audioType(type)].volume
    const percent = volume * 100
    const { muted, low, medium, high } = type === "sink"  ? icons.audio.volume : icons.audio.mic
    const cons = [[67, high], [34, medium], [1, low], [0, muted]]
    return cons.find(([n]) => n <= percent)?.[1] || ""
}

export const VolumeEntry = (type) => Widget.Box({
    children: [
        Widget.Button({
            onClicked: () => {
                audio[audioType(type)].is_muted = !audio[audioType(type)].is_muted
            },
            child: Widget.Icon().hook(audio, self => {self.icon = VolumeIcon(type)}, audioType(type) + "-changed")
        }),
        Widget.Slider({
            hexpand: true,
            draw_value: false,
            onChange: ({ value }) => audio[audioType(type)].volume = value,
            value: audio[audioType(type)].bind("volume"),
        }),
        Widget.Label().hook(audio, self => {
            self.label = `${Math.floor(audio[audioType(type)].volume * 100)}%`
        }, audioType(type) + "-changed")
    ]
})

const AudioSourceEntry = (type) => stream => Widget.Box({
    spacing: 20,
    children: [
        Widget.Label(stream.description?.split(" ").slice(0, 4).join(" ")),
        Widget.Switch({
            hpack: "end",
            onActivate: () => audio[audioType(type)] = stream,
        }).hook(audio, self => {
            self.set_active(audio[audioType(type)].id === stream.id)
        }, audioType(type) + "-changed"),
    ]
})

const AudioList = (type) => Widget.Box({
    vertical: true,
    spacing: 4,
})
.hook(audio, self => {
    self.children = Array.from(audio[audioTypes(type)].values()).map(AudioSourceEntry(type))
}, "stream-added")
.hook(audio, self => {
    self.children = Array.from(audio[audioTypes(type)].values()).map(AudioSourceEntry(type))
}, "stream-removed")


export const AudioMenu = (type) => SubMenu({
    title: type.charAt(0).toUpperCase() + type.slice(1) + " List",
    icon: (type == "sink") ? icons.audio.headphones : icons.audio.mic.high,
    content: AudioList(type)
})
