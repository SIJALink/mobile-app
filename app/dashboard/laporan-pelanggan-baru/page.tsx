
"use client";

import { useState } from "react";

type Pelanggan = {
  id: number;
  nama: string;
  telepon: string;
  alamat: string;
  tanggal: string;
  paket: string;
  jenis: string;
  status: string;
};

export default function LaporanPelangganBaru() {
  const [data, setData] = useState<Pelanggan[]>([
    {
      id: 1,
      nama: "Andi Saputra",
      telepon: "081234567890",
      alamat: "Pasar Kemis, Tangerang",
      tanggal: "20 November 2026",
      paket: "Internet 20 Mbps",
      jenis: "Pemasangan Baru",
      status: "Menunggu",
    },
    {
      id: 2,
      nama: "Siti Rahma",
      telepon: "081298765432",
      alamat: "Rajeg, Tangerang",
      tanggal: "21 November 2026",
      paket: "Internet 30 Mbps",
      jenis: "Pemasangan Baru",
      status: "Diproses",
    },
    {
      id: 3,
      nama: "Budi Santoso",
      telepon: "082112223333",
      alamat: "Sepatan, Tangerang",
      tanggal: "22 November 2026",
      paket: "Internet 20 Mbps",
      jenis: "Pemasangan Ulang",
      status: "Disetujui",
    },
    {
      id: 4,
      nama: "Dewi Anggraini",
      telepon: "085677889900",
      alamat: "Cikupa, Tangerang",
      tanggal: "22 November 2026",
      paket: "Internet 50 Mbps",
      jenis: "Pemasangan Baru",
      status: "Menunggu",
    },
  ]);

  const [cari, setCari] = useState("");
  const [filter, setFilter] = useState("Semua");
  const [detail, setDetail] = useState<Pelanggan | null>(null);

  const total = data.length;
  const menunggu = data.filter(
    (item) => item.status === "Menunggu"
  ).length;
  const diproses = data.filter(
    (item) => item.status === "Diproses"
  ).length;
  const disetujui = data.filter(
    (item) => item.status === "Disetujui"
  ).length;

  const dataFilter = data.filter((item) => {
    const cocokCari =
      item.nama.toLowerCase().includes(cari.toLowerCase()) ||
      item.alamat.toLowerCase().includes(cari.toLowerCase());

    const cocokStatus =
      filter === "Semua" || item.status === filter;

    return cocokCari && cocokStatus;
  });

  function ubahStatus(id: number, status: string) {
    setData((sebelumnya) =>
      sebelumnya.map((item) =>
        item.id === id ? { ...item, status } : item
      )
    );

    setDetail(null);
  }

  return (
    <main className="min-h-screen bg-slate-100 p-4 md:p-8">
      <div className="mx-auto max-w-7xl">

        {/* HEADER */}
        <div className="mb-8">
          <p className="text-sm font-medium text-blue-600">
            Dashboard / Kepala SITE / Laporan Pelanggan Baru
          </p>

          <h1 className="mt-2 text-3xl font-bold text-slate-800">
            Laporan Pelanggan Baru
          </h1>

          <p className="mt-2 text-slate-500">
            Pantau pengajuan pemasangan baru dan pemasangan ulang pelanggan.
          </p>
        </div>

        {/* STATISTIK */}
        <div className="mb-8 grid grid-cols-1 gap-5 sm:grid-cols-2 xl:grid-cols-4">

          <div className="rounded-2xl bg-white p-6 shadow-sm">
            <p className="text-sm text-slate-500">Total Pengajuan</p>
            <h2 className="mt-3 text-3xl font-bold text-slate-800">
              {total}
            </h2>
            <p className="mt-2 text-sm text-blue-600">
              Seluruh pengajuan
            </p>
          </div>

          <div className="rounded-2xl bg-white p-6 shadow-sm">
            <p className="text-sm text-slate-500">Menunggu</p>
            <h2 className="mt-3 text-3xl font-bold text-yellow-600">
              {menunggu}
            </h2>
            <p className="mt-2 text-sm text-slate-500">
              Belum diperiksa
            </p>
          </div>

          <div className="rounded-2xl bg-white p-6 shadow-sm">
            <p className="text-sm text-slate-500">Diproses</p>
            <h2 className="mt-3 text-3xl font-bold text-blue-600">
              {diproses}
            </h2>
            <p className="mt-2 text-sm text-slate-500">
              Sedang ditindaklanjuti
            </p>
          </div>

          <div className="rounded-2xl bg-white p-6 shadow-sm">
            <p className="text-sm text-slate-500">Disetujui</p>
            <h2 className="mt-3 text-3xl font-bold text-green-600">
              {disetujui}
            </h2>
            <p className="mt-2 text-sm text-slate-500">
              Pengajuan diterima
            </p>
          </div>

        </div>

        {/* TABEL */}
        <div className="overflow-hidden rounded-2xl bg-white shadow-sm">

          <div className="flex flex-col justify-between gap-4 border-b border-slate-100 p-6 md:flex-row md:items-center">
            <div>
              <h2 className="text-lg font-bold text-slate-800">
                Data Pengajuan Pelanggan
              </h2>
              <p className="mt-1 text-sm text-slate-500">
                Daftar pengajuan pelanggan SIJALink
              </p>
            </div>

            <div className="flex flex-col gap-3 sm:flex-row">
              <input
                type="text"
                placeholder="Cari nama atau alamat..."
                value={cari}
                onChange={(e) => setCari(e.target.value)}
                className="rounded-xl border border-slate-200 px-4 py-2 text-sm outline-none focus:border-blue-500"
              />

              <select
                value={filter}
                onChange={(e) => setFilter(e.target.value)}
                className="rounded-xl border border-slate-200 px-4 py-2 text-sm outline-none focus:border-blue-500"
              >
                <option value="Semua">Semua Status</option>
                <option value="Menunggu">Menunggu</option>
                <option value="Diproses">Diproses</option>
                <option value="Disetujui">Disetujui</option>
                <option value="Ditolak">Ditolak</option>
              </select>
            </div>
          </div>

          <div className="overflow-x-auto">
            <table className="w-full text-left text-sm">
              <thead className="bg-slate-50 text-slate-600">
                <tr>
                  <th className="p-4">No</th>
                  <th className="p-4">Nama Pelanggan</th>
                  <th className="p-4">Tanggal</th>
                  <th className="p-4">Jenis Pengajuan</th>
                  <th className="p-4">Paket</th>
                  <th className="p-4">Status</th>
                  <th className="p-4">Aksi</th>
                </tr>
              </thead>

              <tbody>
                {dataFilter.map((item, index) => (
                  <tr
                    key={item.id}
                    className="border-t border-slate-100 hover:bg-slate-50"
                  >
                    <td className="p-4">{index + 1}</td>

                    <td className="p-4">
                      <p className="font-semibold text-slate-800">
                        {item.nama}
                      </p>
                      <p className="text-xs text-slate-500">
                        {item.telepon}
                      </p>
                    </td>

                    <td className="p-4 text-slate-600">
                      {item.tanggal}
                    </td>

                    <td className="p-4 text-slate-600">
                      {item.jenis}
                    </td>

                    <td className="p-4 text-slate-600">
                      {item.paket}
                    </td>

                    <td className="p-4">
                      <span
                        className={`rounded-full px-3 py-1 text-xs font-semibold ${
                          item.status === "Disetujui"
                            ? "bg-green-100 text-green-700"
                            : item.status === "Diproses"
                            ? "bg-blue-100 text-blue-700"
                            : item.status === "Ditolak"
                            ? "bg-red-100 text-red-700"
                            : "bg-yellow-100 text-yellow-700"
                        }`}
                      >
                        {item.status}
                      </span>
                    </td>

                    <td className="p-4">
                      <button
                        onClick={() => setDetail(item)}
                        className="rounded-lg bg-blue-600 px-4 py-2 text-xs font-semibold text-white hover:bg-blue-700"
                      >
                        Detail
                      </button>
                    </td>
                  </tr>
                ))}

                {dataFilter.length === 0 && (
                  <tr>
                    <td
                      colSpan={7}
                      className="p-8 text-center text-slate-500"
                    >
                      Data pelanggan tidak ditemukan.
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        </div>

        {/* DETAIL MODAL */}
        {detail && (
          <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 p-4">
            <div className="w-full max-w-lg rounded-2xl bg-white p-6 shadow-xl">

              <div className="mb-5 flex items-center justify-between">
                <h2 className="text-xl font-bold text-slate-800">
                  Detail Pelanggan
                </h2>

                <button
                  onClick={() => setDetail(null)}
                  className="text-2xl text-slate-400 hover:text-slate-700"
                >
                  ×
                </button>
              </div>

              <div className="space-y-4 text-sm">
                <div>
                  <p className="text-slate-500">Nama Lengkap</p>
                  <p className="font-semibold text-slate-800">
                    {detail.nama}
                  </p>
                </div>

                <div>
                  <p className="text-slate-500">Nomor Telepon</p>
                  <p className="font-semibold text-slate-800">
                    {detail.telepon}
                  </p>
                </div>

                <div>
                  <p className="text-slate-500">Alamat</p>
                  <p className="font-semibold text-slate-800">
                    {detail.alamat}
                  </p>
                </div>

                <div>
                  <p className="text-slate-500">Tanggal Pengajuan</p>
                  <p className="font-semibold text-slate-800">
                    {detail.tanggal}
                  </p>
                </div>

                <div>
                  <p className="text-slate-500">Jenis Pengajuan</p>
                  <p className="font-semibold text-slate-800">
                    {detail.jenis}
                  </p>
                </div>

                <div>
                  <p className="text-slate-500">Paket Internet</p>
                  <p className="font-semibold text-slate-800">
                    {detail.paket}
                  </p>
                </div>

                <div>
                  <p className="text-slate-500">Status</p>
                  <p className="font-semibold text-blue-600">
                    {detail.status}
                  </p>
                </div>
              </div>

              <div className="mt-7 border-t border-slate-100 pt-5">
                <p className="mb-3 text-sm font-semibold text-slate-700">
                  Ubah Status Pengajuan
                </p>

                <div className="grid grid-cols-2 gap-3">
                  <button
                    onClick={() =>
                      ubahStatus(detail.id, "Diproses")
                    }
                    className="rounded-xl bg-blue-600 px-3 py-3 text-sm font-semibold text-white hover:bg-blue-700"
                  >
                    Proses
                  </button>

                  <button
                    onClick={() =>
                      ubahStatus(detail.id, "Disetujui")
                    }
                    className="rounded-xl bg-green-600 px-3 py-3 text-sm font-semibold text-white hover:bg-green-700"
                  >
                    Setujui
                  </button>

                  <button
                    onClick={() =>
                      ubahStatus(detail.id, "Ditolak")
                    }
                    className="col-span-2 rounded-xl bg-red-600 px-3 py-3 text-sm font-semibold text-white hover:bg-red-700"
                  >
                    Tolak Pengajuan
                  </button>
                </div>
              </div>

            </div>
          </div>
        )}

      </div>
    </main>
  );
}
