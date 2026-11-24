
"use client";

import { useState } from "react";

type GuruPiket = {
  id: number;
  nama: string;
  hari: string;
  tanggal: string;
  waktu: string;
  lokasi: string;
  checklist: number;
  totalChecklist: number;
  status: "Selesai" | "Sedang Bertugas" | "Belum Bertugas";
};

const dataAwal: GuruPiket[] = [
  {
    id: 1,
    nama: "Andi Saputra",
    hari: "Minggu",
    tanggal: "22 November 2026",
    waktu: "07.00 - 12.00",
    lokasi: "Area Utama",
    checklist: 8,
    totalChecklist: 8,
    status: "Selesai",
  },
  {
    id: 2,
    nama: "Budi Santoso",
    hari: "Minggu",
    tanggal: "22 November 2026",
    waktu: "07.00 - 12.00",
    lokasi: "Area Timur",
    checklist: 5,
    totalChecklist: 8,
    status: "Sedang Bertugas",
  },
  {
    id: 3,
    nama: "Dedi Kurniawan",
    hari: "Minggu",
    tanggal: "22 November 2026",
    waktu: "12.00 - 17.00",
    lokasi: "Area Barat",
    checklist: 0,
    totalChecklist: 8,
    status: "Belum Bertugas",
  },
  {
    id: 4,
    nama: "Rizky Pratama",
    hari: "Minggu",
    tanggal: "22 November 2026",
    waktu: "07.00 - 12.00",
    lokasi: "Area Selatan",
    checklist: 6,
    totalChecklist: 8,
    status: "Sedang Bertugas",
  },
  {
    id: 5,
    nama: "Fajar Ramadhan",
    hari: "Minggu",
    tanggal: "22 November 2026",
    waktu: "12.00 - 17.00",
    lokasi: "Area Utara",
    checklist: 8,
    totalChecklist: 8,
    status: "Selesai",
  },
];

export default function MonitoringPiketPage() {
  const [data] = useState(dataAwal);
  const [cari, setCari] = useState("");
  const [filter, setFilter] = useState("Semua");
  const [detail, setDetail] = useState<GuruPiket | null>(null);

  const selesai = data.filter(
    (item) => item.status === "Selesai"
  ).length;

  const bertugas = data.filter(
    (item) => item.status === "Sedang Bertugas"
  ).length;

  const belum = data.filter(
    (item) => item.status === "Belum Bertugas"
  ).length;

  const hasilFilter = data.filter((item) => {
    const cocokCari =
      item.nama.toLowerCase().includes(cari.toLowerCase()) ||
      item.lokasi.toLowerCase().includes(cari.toLowerCase());

    const cocokStatus =
      filter === "Semua" || item.status === filter;

    return cocokCari && cocokStatus;
  });

  return (
    <main className="min-h-screen bg-slate-100 p-4 md:p-8">
      <div className="mx-auto max-w-7xl space-y-6">

        {/* HEADER */}
        <div>
          <p className="text-sm font-medium text-blue-600">
            SIJALink / Kepala SITE / Monitoring Piket
          </p>

          <h1 className="mt-2 text-2xl font-bold text-slate-800 md:text-3xl">
            Monitoring Pelaksanaan Guru Piket
          </h1>

          <p className="mt-2 text-sm text-slate-500">
            Pantau pelaksanaan tugas dan aktivitas Guru Piket.
          </p>
        </div>

        {/* RINGKASAN */}
        <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">

          <div className="rounded-2xl bg-white p-5 shadow-sm">
            <p className="text-sm text-slate-500">Total Guru Piket</p>
            <h2 className="mt-3 text-3xl font-bold text-slate-800">
              {data.length}
            </h2>
            <p className="mt-2 text-xs text-slate-400">
              Guru terjadwal
            </p>
          </div>

          <div className="rounded-2xl bg-white p-5 shadow-sm">
            <p className="text-sm text-slate-500">Sudah Selesai</p>
            <h2 className="mt-3 text-3xl font-bold text-green-600">
              {selesai}
            </h2>
            <p className="mt-2 text-xs text-slate-400">
              Tugas diselesaikan
            </p>
          </div>

          <div className="rounded-2xl bg-white p-5 shadow-sm">
            <p className="text-sm text-slate-500">Sedang Bertugas</p>
            <h2 className="mt-3 text-3xl font-bold text-blue-600">
              {bertugas}
            </h2>
            <p className="mt-2 text-xs text-slate-400">
              Sedang menjalankan tugas
            </p>
          </div>

          <div className="rounded-2xl bg-white p-5 shadow-sm">
            <p className="text-sm text-slate-500">Belum Bertugas</p>
            <h2 className="mt-3 text-3xl font-bold text-orange-500">
              {belum}
            </h2>
            <p className="mt-2 text-xs text-slate-400">
              Belum memulai tugas
            </p>
          </div>

        </div>

        {/* RINGKASAN PROGRES */}
        <section className="rounded-2xl bg-white p-5 shadow-sm md:p-6">
          <h2 className="text-lg font-bold text-slate-800">
            Progres Checklist Keseluruhan
          </h2>

          <p className="mt-1 text-sm text-slate-500">
            Ringkasan penyelesaian checklist Guru Piket.
          </p>

          <div className="mt-5 flex items-center justify-between text-sm">
            <span className="text-slate-500">Checklist selesai</span>
            <span className="font-bold text-blue-600">
              {data.reduce((total, item) => total + item.checklist, 0)} /{" "}
              {data.reduce((total, item) => total + item.totalChecklist, 0)}
            </span>
          </div>

          <div className="mt-3 h-3 overflow-hidden rounded-full bg-slate-100">
            <div
              className="h-full rounded-full bg-blue-600"
              style={{
                width: `${
                  (data.reduce((total, item) => total + item.checklist, 0) /
                    data.reduce((total, item) => total + item.totalChecklist, 0)) *
                  100
                }%`,
              }}
            />
          </div>
        </section>

        {/* DAFTAR GURU */}
        <section className="rounded-2xl bg-white p-5 shadow-sm md:p-6">

          <div className="flex flex-col justify-between gap-4 md:flex-row md:items-center">
            <div>
              <h2 className="text-lg font-bold text-slate-800">
                Daftar Pelaksanaan Piket
              </h2>
              <p className="mt-1 text-sm text-slate-500">
                Informasi jadwal dan status tugas Guru Piket.
              </p>
            </div>

            <input
              type="text"
              placeholder="Cari nama atau lokasi..."
              value={cari}
              onChange={(e) => setCari(e.target.value)}
              className="w-full rounded-xl border border-slate-200 px-4 py-3 text-sm outline-none focus:border-blue-500 md:w-72"
            />
          </div>

          {/* FILTER */}
          <div className="mt-5 flex flex-wrap gap-2">
            {[
              "Semua",
              "Selesai",
              "Sedang Bertugas",
              "Belum Bertugas",
            ].map((item) => (
              <button
                key={item}
                onClick={() => setFilter(item)}
                className={`rounded-xl px-4 py-2 text-sm font-semibold ${
                  filter === item
                    ? "bg-blue-600 text-white"
                    : "bg-slate-100 text-slate-600 hover:bg-slate-200"
                }`}
              >
                {item}
              </button>
            ))}
          </div>

          {/* TABEL */}
          <div className="mt-5 overflow-x-auto">
            <table className="w-full min-w-[850px] text-left text-sm">
              <thead>
                <tr className="border-b bg-slate-50 text-slate-500">
                  <th className="px-4 py-4">No</th>
                  <th className="px-4 py-4">Nama Guru</th>
                  <th className="px-4 py-4">Jadwal</th>
                  <th className="px-4 py-4">Waktu</th>
                  <th className="px-4 py-4">Lokasi</th>
                  <th className="px-4 py-4">Checklist</th>
                  <th className="px-4 py-4">Status</th>
                  <th className="px-4 py-4">Aksi</th>
                </tr>
              </thead>

              <tbody>
                {hasilFilter.map((item, index) => (
                  <tr
                    key={item.id}
                    className="border-b border-slate-100 hover:bg-slate-50"
                  >
                    <td className="px-4 py-4">{index + 1}</td>

                    <td className="px-4 py-4 font-semibold text-slate-700">
                      {item.nama}
                    </td>

                    <td className="px-4 py-4 text-slate-500">
                      {item.tanggal}
                    </td>

                    <td className="px-4 py-4">{item.waktu}</td>

                    <td className="px-4 py-4">{item.lokasi}</td>

                    <td className="px-4 py-4">
                      <div className="font-semibold text-slate-700">
                        {item.checklist}/{item.totalChecklist}
                      </div>
                      <div className="mt-1 h-2 w-20 rounded-full bg-slate-100">
                        <div
                          className="h-2 rounded-full bg-blue-600"
                          style={{
                            width: `${
                              (item.checklist / item.totalChecklist) * 100
                            }%`,
                          }}
                        />
                      </div>
                    </td>

                    <td className="px-4 py-4">
                      <span
                        className={`rounded-full px-3 py-1 text-xs font-semibold ${
                          item.status === "Selesai"
                            ? "bg-green-100 text-green-700"
                            : item.status === "Sedang Bertugas"
                            ? "bg-blue-100 text-blue-700"
                            : "bg-orange-100 text-orange-700"
                        }`}
                      >
                        {item.status}
                      </span>
                    </td>

                    <td className="px-4 py-4">
                      <button
                        onClick={() => setDetail(item)}
                        className="rounded-lg bg-blue-50 px-3 py-2 text-xs font-semibold text-blue-600 hover:bg-blue-100"
                      >
                        Detail
                      </button>
                    </td>
                  </tr>
                ))}

                {hasilFilter.length === 0 && (
                  <tr>
                    <td
                      colSpan={8}
                      className="px-4 py-10 text-center text-slate-400"
                    >
                      Data tidak ditemukan.
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        </section>

        {/* DETAIL */}
        {detail && (
          <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 p-4">
            <div className="w-full max-w-md rounded-2xl bg-white p-6 shadow-xl">

              <div className="flex items-center justify-between">
                <h2 className="text-xl font-bold text-slate-800">
                  Detail Guru Piket
                </h2>

                <button
                  onClick={() => setDetail(null)}
                  className="text-2xl text-slate-400"
                >
                  ×
                </button>
              </div>

              <div className="mt-5 space-y-4">
                <div>
                  <p className="text-xs text-slate-400">Nama Guru</p>
                  <p className="font-semibold text-slate-800">{detail.nama}</p>
                </div>

                <div>
                  <p className="text-xs text-slate-400">Hari dan Tanggal</p>
                  <p className="font-semibold text-slate-800">
                    {detail.hari}, {detail.tanggal}
                  </p>
                </div>

                <div>
                  <p className="text-xs text-slate-400">Waktu Bertugas</p>
                  <p className="font-semibold text-slate-800">{detail.waktu}</p>
                </div>

                <div>
                  <p className="text-xs text-slate-400">Lokasi</p>
                  <p className="font-semibold text-slate-800">{detail.lokasi}</p>
                </div>

                <div>
                  <p className="text-xs text-slate-400">Progres Checklist</p>
                  <p className="font-semibold text-slate-800">
                    {detail.checklist} dari {detail.totalChecklist} tugas selesai
                  </p>
                </div>

                <div>
                  <p className="text-xs text-slate-400">Status</p>
                  <p className="font-semibold text-slate-800">{detail.status}</p>
                </div>
              </div>

              <button
                onClick={() => setDetail(null)}
                className="mt-6 w-full rounded-xl bg-blue-600 py-3 text-sm font-semibold text-white hover:bg-blue-700"
              >
                Tutup
              </button>

            </div>
          </div>
        )}

      </div>
    </main>
  );
}
