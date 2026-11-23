
"use client";

import { useMemo, useState } from "react";

type Kinerja = {
  id: number;
  nama: string;
  jabatan: string;
  penugasan: number;
  selesai: number;
  laporan: number;
  ketepatan: number;
  status: string;
};

export default function LaporanKinerja() {
  const [data] = useState<Kinerja[]>([
    {
      id: 1,
      nama: "Andi Saputra",
      jabatan: "Teknisi",
      penugasan: 15,
      selesai: 13,
      laporan: 13,
      ketepatan: 95,
      status: "Baik",
    },
    {
      id: 2,
      nama: "Budi Santoso",
      jabatan: "Petugas Lapangan",
      penugasan: 12,
      selesai: 10,
      laporan: 10,
      ketepatan: 88,
      status: "Baik",
    },
    {
      id: 3,
      nama: "Dedi Kurniawan",
      jabatan: "Teknisi",
      penugasan: 10,
      selesai: 7,
      laporan: 7,
      ketepatan: 75,
      status: "Cukup",
    },
    {
      id: 4,
      nama: "Rizky Pratama",
      jabatan: "Supervisor",
      penugasan: 14,
      selesai: 14,
      laporan: 14,
      ketepatan: 98,
      status: "Sangat Baik",
    },
  ]);

  const [cari, setCari] = useState("");
  const [filter, setFilter] = useState("Semua");
  const [detail, setDetail] = useState<Kinerja | null>(null);

  const hasil = useMemo(() => {
    return data.filter((item) => {
      const cocokNama = item.nama
        .toLowerCase()
        .includes(cari.toLowerCase());

      const cocokStatus =
        filter === "Semua" || item.status === filter;

      return cocokNama && cocokStatus;
    });
  }, [data, cari, filter]);

  const totalPetugas = data.length;
  const totalPenugasan = data.reduce(
    (jumlah, item) => jumlah + item.penugasan,
    0
  );
  const totalSelesai = data.reduce(
    (jumlah, item) => jumlah + item.selesai,
    0
  );
  const totalLaporan = data.reduce(
    (jumlah, item) => jumlah + item.laporan,
    0
  );

  return (
    <main className="min-h-screen bg-slate-100 p-4 md:p-8">
      <div className="mx-auto max-w-7xl space-y-6">

        {/* HEADER */}
        <div className="flex flex-col justify-between gap-3 md:flex-row md:items-center">
          <div>
            <p className="text-sm font-medium text-blue-600">
              Dashboard Kepala SITE
            </p>
            <h1 className="mt-1 text-2xl font-bold text-slate-800">
              Laporan Kinerja Petugas
            </h1>
            <p className="mt-1 text-sm text-slate-500">
              Ringkasan hasil penugasan dan aktivitas petugas.
            </p>
          </div>

          <div className="rounded-xl bg-white px-4 py-3 shadow-sm">
            <p className="text-xs text-slate-500">Periode laporan</p>
            <p className="font-semibold text-slate-700">
              November 2026
            </p>
          </div>
        </div>

        {/* STATISTIK */}
        <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-4">
          <div className="rounded-2xl bg-white p-5 shadow-sm">
            <p className="text-sm text-slate-500">Total Petugas</p>
            <h2 className="mt-2 text-3xl font-bold text-blue-600">
              {totalPetugas}
            </h2>
            <p className="mt-2 text-xs text-slate-400">
              Petugas terdaftar dalam laporan
            </p>
          </div>

          <div className="rounded-2xl bg-white p-5 shadow-sm">
            <p className="text-sm text-slate-500">Total Penugasan</p>
            <h2 className="mt-2 text-3xl font-bold text-indigo-600">
              {totalPenugasan}
            </h2>
            <p className="mt-2 text-xs text-slate-400">
              Seluruh tugas yang diberikan
            </p>
          </div>

          <div className="rounded-2xl bg-white p-5 shadow-sm">
            <p className="text-sm text-slate-500">Penugasan Selesai</p>
            <h2 className="mt-2 text-3xl font-bold text-green-600">
              {totalSelesai}
            </h2>
            <p className="mt-2 text-xs text-slate-400">
              Tugas yang telah diselesaikan
            </p>
          </div>

          <div className="rounded-2xl bg-white p-5 shadow-sm">
            <p className="text-sm text-slate-500">Laporan Masuk</p>
            <h2 className="mt-2 text-3xl font-bold text-orange-500">
              {totalLaporan}
            </h2>
            <p className="mt-2 text-xs text-slate-400">
              Laporan dari seluruh petugas
            </p>
          </div>
        </div>

        {/* INFORMASI */}
        <div className="rounded-2xl border border-blue-100 bg-blue-50 p-5">
          <h3 className="font-semibold text-blue-800">
            Ringkasan Kinerja
          </h3>
          <p className="mt-2 text-sm leading-6 text-blue-700">
            Halaman ini digunakan Kepala SITE untuk memantau
            jumlah penugasan, penyelesaian pekerjaan, laporan,
            dan ketepatan waktu petugas.
          </p>
        </div>

        {/* TABEL */}
        <div className="overflow-hidden rounded-2xl bg-white shadow-sm">
          <div className="flex flex-col justify-between gap-4 border-b p-5 md:flex-row md:items-center">
            <div>
              <h2 className="text-lg font-bold text-slate-800">
                Daftar Kinerja Petugas
              </h2>
              <p className="mt-1 text-sm text-slate-500">
                Data penilaian setiap petugas.
              </p>
            </div>

            <div className="flex flex-col gap-2 sm:flex-row">
              <input
                type="text"
                placeholder="Cari nama petugas..."
                value={cari}
                onChange={(e) => setCari(e.target.value)}
                className="rounded-lg border px-4 py-2 text-sm outline-none focus:border-blue-500"
              />

              <select
                value={filter}
                onChange={(e) => setFilter(e.target.value)}
                className="rounded-lg border px-3 py-2 text-sm outline-none focus:border-blue-500"
              >
                <option value="Semua">Semua Status</option>
                <option value="Sangat Baik">Sangat Baik</option>
                <option value="Baik">Baik</option>
                <option value="Cukup">Cukup</option>
              </select>
            </div>
          </div>

          <div className="overflow-x-auto">
            <table className="w-full min-w-[850px] text-left text-sm">
              <thead className="bg-slate-50 text-slate-600">
                <tr>
                  <th className="px-5 py-4">Petugas</th>
                  <th className="px-5 py-4">Penugasan</th>
                  <th className="px-5 py-4">Selesai</th>
                  <th className="px-5 py-4">Laporan</th>
                  <th className="px-5 py-4">Ketepatan</th>
                  <th className="px-5 py-4">Penilaian</th>
                  <th className="px-5 py-4">Aksi</th>
                </tr>
              </thead>

              <tbody>
                {hasil.map((item) => (
                  <tr
                    key={item.id}
                    className="border-t hover:bg-slate-50"
                  >
                    <td className="px-5 py-4">
                      <p className="font-semibold text-slate-800">
                        {item.nama}
                      </p>
                      <p className="text-xs text-slate-500">
                        {item.jabatan}
                      </p>
                    </td>

                    <td className="px-5 py-4 text-slate-700">
                      {item.penugasan}
                    </td>

                    <td className="px-5 py-4 font-semibold text-green-600">
                      {item.selesai}
                    </td>

                    <td className="px-5 py-4 text-slate-700">
                      {item.laporan}
                    </td>

                    <td className="px-5 py-4 text-slate-700">
                      {item.ketepatan}%
                    </td>

                    <td className="px-5 py-4">
                      <span
                        className={`rounded-full px-3 py-1 text-xs font-semibold ${
                          item.status === "Sangat Baik"
                            ? "bg-green-100 text-green-700"
                            : item.status === "Baik"
                            ? "bg-blue-100 text-blue-700"
                            : "bg-orange-100 text-orange-700"
                        }`}
                      >
                        {item.status}
                      </span>
                    </td>

                    <td className="px-5 py-4">
                      <button
                        onClick={() => setDetail(item)}
                        className="rounded-lg bg-blue-600 px-3 py-2 text-xs font-semibold text-white hover:bg-blue-700"
                      >
                        Detail
                      </button>
                    </td>
                  </tr>
                ))}

                {hasil.length === 0 && (
                  <tr>
                    <td
                      colSpan={7}
                      className="px-5 py-8 text-center text-slate-500"
                    >
                      Data petugas tidak ditemukan.
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        </div>

        {/* MODAL DETAIL */}
        {detail && (
          <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 p-4">
            <div className="w-full max-w-md rounded-2xl bg-white p-6 shadow-xl">
              <div className="flex items-center justify-between">
                <h2 className="text-lg font-bold text-slate-800">
                  Detail Kinerja
                </h2>
                <button
                  onClick={() => setDetail(null)}
                  className="text-xl text-slate-500 hover:text-red-500"
                >
                  ✕
                </button>
              </div>

              <div className="mt-5 space-y-4">
                <div>
                  <p className="text-xs text-slate-500">Nama Petugas</p>
                  <p className="font-semibold text-slate-800">
                    {detail.nama}
                  </p>
                </div>

                <div>
                  <p className="text-xs text-slate-500">Jabatan</p>
                  <p className="font-semibold text-slate-800">
                    {detail.jabatan}
                  </p>
                </div>

                <div className="grid grid-cols-2 gap-3">
                  <div className="rounded-xl bg-slate-50 p-3">
                    <p className="text-xs text-slate-500">Penugasan</p>
                    <p className="mt-1 text-xl font-bold text-blue-600">
                      {detail.penugasan}
                    </p>
                  </div>

                  <div className="rounded-xl bg-slate-50 p-3">
                    <p className="text-xs text-slate-500">Selesai</p>
                    <p className="mt-1 text-xl font-bold text-green-600">
                      {detail.selesai}
                    </p>
                  </div>

                  <div className="rounded-xl bg-slate-50 p-3">
                    <p className="text-xs text-slate-500">Laporan</p>
                    <p className="mt-1 text-xl font-bold text-orange-500">
                      {detail.laporan}
                    </p>
                  </div>

                  <div className="rounded-xl bg-slate-50 p-3">
                    <p className="text-xs text-slate-500">Ketepatan</p>
                    <p className="mt-1 text-xl font-bold text-indigo-600">
                      {detail.ketepatan}%
                    </p>
                  </div>
                </div>

                <div>
                  <p className="text-xs text-slate-500">Penilaian</p>
                  <p className="mt-1 font-semibold text-slate-800">
                    {detail.status}
                  </p>
                </div>
              </div>

              <button
                onClick={() => setDetail(null)}
                className="mt-6 w-full rounded-lg bg-blue-600 py-3 font-semibold text-white hover:bg-blue-700"
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
