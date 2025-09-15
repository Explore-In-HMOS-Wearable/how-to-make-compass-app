import { sensor } from "@kit.SensorServiceKit";

@Entry
@Component
export struct Index {
  @State azimuth: number = 0

  onPageShow() {
    sensor.on(sensor.SensorId.ROTATION_VECTOR, (data: sensor.RotationVectorResponse) => {
      const x = data.x
      const y = data.y
      const z = data.z
      const w = data.w

      const siny_cosp = 2 * (w * z + x * y)
      const cosy_cosp = 1 - 2 * (y * y + z * z)
      const azimuthRad = Math.atan2(siny_cosp, cosy_cosp)
      const azimuthDeg = (azimuthRad * 180 / Math.PI + 360) % 360

      this.azimuth = Math.round(azimuthDeg)
    }, {
      interval: 100_000_000
    })
  }

  aboutToAppear() {
    this.onPageShow()
  }

  aboutToDisappear() {
    sensor.off(sensor.SensorId.ROTATION_VECTOR)
  }

  build() {
    NavDestination() {

      Stack() {
        Rect()
          .width('100%')
          .height('100%')

        Column({ space: 20 }) {
          Text(`Azimuth: ${this.azimuth}°`)
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)

          Image($r('app.media.compass_vector'))
            .width(150)
            .height(150)
            .rotate({ angle: -this.azimuth })
        }
      }
      .width('100%')
      .height('100%')

    }
    .hideTitleBar(true)

  }
}