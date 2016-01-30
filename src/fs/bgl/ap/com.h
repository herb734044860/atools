/*****************************************************************************
* Copyright 2015-2016 Alexander Barthel albar965@mailbox.org
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>.
*****************************************************************************/

#ifndef BGL_AIRPORTCOM_H_
#define BGL_AIRPORTCOM_H_

#include "fs/bgl/record.h"

#include <QString>

namespace atools {
namespace io {
class BinaryStream;
}
}

namespace atools {
namespace fs {
namespace bgl {

namespace com {
enum ComType
{
  NONE = 0x0000,
  ATIS = 0x0001,
  MULTICOM = 0x0002,
  UNICOM = 0x0003,
  CTAF = 0x0004,
  GROUND = 0x0005,
  TOWER = 0x0006,
  CLEARANCE = 0x0007,
  APPROACH = 0x0008,
  DEPARTURE = 0x0009,
  CENTER = 0x000A,
  FSS = 0x000B,
  AWOS = 0x000C,
  ASOS = 0x000D,
  CLEARANCE_PRE_TAXI = 0x000E,
  REMOTE_CLEARANCE_DELIVERY = 0x000F
};

} // namespace com

class Com :
  public atools::fs::bgl::Record
{
public:
  Com()
    : type(atools::fs::bgl::com::NONE), frequency(0.0f)
  {
  }

  Com(const atools::fs::BglReaderOptions *options, atools::io::BinaryStream *bs);

  virtual ~Com();

  int getFrequency() const
  {
    return frequency;
  }

  const QString& getName() const
  {
    return name;
  }

  atools::fs::bgl::com::ComType getType() const
  {
    return type;
  }

  QString getTypeAsString() const
  {
    return comTypeToStr(type);
  }

  static QString comTypeToStr(atools::fs::bgl::com::ComType type);

private:
  friend QDebug operator<<(QDebug out, const atools::fs::bgl::Com& record);

  atools::fs::bgl::com::ComType type;
  int frequency;
  QString name;
};

} // namespace bgl
} // namespace fs
} // namespace atools

#endif /* BGL_AIRPORTCOM_H_ */