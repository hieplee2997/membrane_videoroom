defmodule Membrane.Demo.RTP.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :membrane_demo_rtp,
      version: @version,
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:membrane_core, "~> 0.8.0"},
      {:membrane_rtp_plugin, "~> 0.10.0"},
      {:membrane_element_udp, "~> 0.6.0"},
      {:membrane_rtp_h264_plugin, "~> 0.7.1"},
      {:membrane_opus_plugin, "~> 0.9.0"},
      {:membrane_h264_ffmpeg_plugin, "~> 0.15.0"},
      {:membrane_rtp_opus_plugin, "~> 0.4.0"},
      {:membrane_sdl_plugin, "~> 0.11.0"},
      {:membrane_portaudio_plugin, "~> 0.10.0"},
      {:membrane_hackney_plugin, "~> 0.6.0"},
      {:ex_libsrtp, "~> 0.3.0"},
      {:membrane_realtimer_plugin, "~> 0.4.0"}
    ]
  end
end
