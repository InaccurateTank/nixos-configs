import { Capitalize, icons } from "../../utils.js"
import SubMenu from "./submenu.js"

const Audio = await Service.import('audio')

const StreamTypes = {
    sink: {
        icon: icons.audio.headphones,
        icon_list: icons.audio.volume,
        signal: "speaker-changed",
        stream: Audio.speaker,
        StreamList: () => Audio.speakers,
    },
    source: {
        icon: icons.audio.mic.high,
        icon_list: icons.audio.mic,
        signal: "microphone-changed",
        stream: Audio.microphone,
        StreamList: () => Audio.microphones,
    },
}

const MixerEntry = stream => Widget.Box({
    class_name: "mixer-entry",
    children: [
        Widget.Icon({
            icon: stream.bind("icon_name").transform(() => {
                const icons = {
                    Firefox: "firefox",
                }
                return icons[stream.name] || stream.icon_name
            }),
            tooltip_text: stream.bind("name").transform(name => name || ""),
            size: 30,
        }),

        Widget.Box({
            vertical: true,
            children: [
                Widget.Label({
                    hexpand: true,
                    xalign: 0,
                    truncate: "end",
                    label: stream.bind("name").transform(name => name || ""),
                }),

                // Slider Box
                Widget.Box({
                    children: [
                        // Slider
                        Widget.Slider({
                            draw_value: false,
                            hexpand: true,
                            vpack: "center",
                            onChange: ({ value }) => stream.volume = value,
                            value: stream.bind("volume"),
                        }),

                        // Percentage Label
                        Widget.Label({
                            label: stream.bind("volume").transform(volume => `${Math.floor(volume * 100)}%`)
                        })
                    ]
                })
            ]
        })
    ]
})

const AudioEntry = (stream_type) => stream => Widget.Button({
    hexpand: true,
    onClicked: () => stream_type.stream = stream,
    child: Widget.Box({
        children: [
            Widget.Label(stream.description?.split(" ").slice(0, 4).join(" ")),
            Widget.Icon({
                hexpand: true,
                hpack: "end",
                icon: icons.tick,
                visible: stream_type.stream.bind("stream").as(s => s === stream.stream),
            })
        ]
    })
})

const AudioList = (stream_type) => Widget.Box({
    vertical: true,
    spacing: 8,
    setup: self => {
        self.hook(Audio, self => {
            self.children = Array.from(stream_type.StreamList().values())
                .map(AudioEntry(stream_type))
        }, "stream-added")
        self.hook(Audio, self => {
            self.children = Array.from(stream_type.StreamList().values())
                .map(AudioEntry(stream_type))
        }, "stream-removed")
    },
})

// For Export
const VolumeEntry = (type) => {
    const stream_type = StreamTypes[type]
    return Widget.Box({
        class_name: "volume-entry",
        children: [
            // Mute Button
            Widget.Button({
                onClicked: () => {stream_type.stream.is_muted = !stream_type.stream.is_muted},
                child: Widget.Icon()
                    .hook(Audio, self => {
                        const percent = stream_type.stream.volume * 100
                        self.icon = [
                            [67, stream_type.icon_list.high],
                            [34, stream_type.icon_list.medium],
                            [1, stream_type.icon_list.low],
                            [0, stream_type.icon_list.muted]
                        ].find(([n]) => n <= percent)?.[1] || ""
                    }, stream_type.signal),
            }),

            // Slider
            Widget.Slider({
                draw_value: false,
                hexpand: true,
                vpack: "center",
                onChange: ({ value }) => stream_type.stream.volume = value,
                value: stream_type.stream.bind("volume"),
            }),

            // Percentage Label
            Widget.Label().hook(Audio, self => {
                self.label = `${Math.floor(stream_type.stream.volume * 100)}%`
            }, stream_type.signal)
        ]
    })
}

const AudioMenu = (type) => {
    const stream_type = StreamTypes[type]
    return SubMenu({
        title: Capitalize(type) + " List",
        icon: stream_type.icon,
        content: AudioList(stream_type)
    })
}

const MixerMenu = () => SubMenu({
    title: "Programs",
    icon: icons.audio.equalizer,
    content: Widget.Box({
        vertical: true,
        setup: self => self.hook(Audio, self => {self.children = Audio.apps.map(MixerEntry)}, "notify::apps")
    })
})

const AudioWidgets = {
    VolumeEntry,
    AudioMenu,
    MixerMenu,
}

export default AudioWidgets
