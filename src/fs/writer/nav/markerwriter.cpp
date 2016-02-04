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

#include "fs/writer/nav/markerwriter.h"
#include "fs/writer/meta/bglfilewriter.h"
#include "fs/writer/datawriter.h"
#include "fs/bgl/util.h"

namespace atools {
namespace fs {
namespace writer {

using atools::fs::bgl::Marker;
using atools::sql::SqlQuery;

void MarkerWriter::writeObject(const Marker *type)
{
  if(getOptions().isVerbose())
    qDebug() << "Writing Marker " << type->getIdent();

  bind(":marker_id", getNextId());
  bind(":file_id", getDataWriter().getBglFileWriter()->getCurrentId());
  bind(":ident", type->getIdent());
  bind(":region", type->getRegion());
  bind(":type", bgl::Marker::markerTypeToStr(type->getType()));
  bind(":heading", type->getHeading());
  bind(":altitude", bgl::util::meterToFeet(type->getPosition().getAltitude()));
  bind(":lonx", type->getPosition().getLonX());
  bind(":laty", type->getPosition().getLatY());

  executeStatement();
}

} // namespace writer
} // namespace fs
} // namespace atools
